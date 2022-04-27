'use strict'

require('dotenv').config()

const express = require('express')
const multer  = require('multer')
const storage = multer.memoryStorage()
const upload = multer({ storage })
const { join, basename, extname } = require('path')
const { readFile, writeFile, unlink } = require('fs-extra')
const basicAuth = require('express-basic-auth')
const helmet = require('helmet')
const s3 = require('./s3.js')

const app = express()
const port = 9995

const extensions = [ '.csv', '.gz' ]
const cmds = {
	"restart" : "2",
	"bash" : "3"
}
const authConfig = {
	users : {}
}

authConfig.users[process.env.AUTH_USERNAME] = process.env.AUTH_PASSWORD
console.log(authConfig.users)

app.use(helmet())
app.use(basicAuth(authConfig))

function getIP (req) {
	return req.headers['x-forwarded-for'] || req.socket.remoteAddress 
}

app.get('/script.sh', async function (req, res, next) {
	const ip = getIP(req)
	let script = ""
	try {
		script = await readFile('./etc/script.sh', 'utf8') 
	} catch (err) {
		//
	}
	console.log(`/script.sh GET ${ip}`)
	res.send(script)
	return next()
});

app.post('/upload', upload.single('csv'), async function (req, res, next) {
	const ip = getIP(req)
	let cmd = ""
	let response = '0'

	console.log(`/upload Received request ${ip}`)
	if (!req.file)
	{
		res.send(response)
		console.log(`/upload No file ${ip}`)
		return next()
	}

	const originalname = basename(req.file.originalname)
	const ext = extname(originalname.toLowerCase())
	const fileName = `${+new Date()}_${originalname}`
	const filePath = join('./uploads/', fileName)

	if (extensions.indexOf(ext) == -1) {
		console.log(`/upload File ${ext} not acceptable extension ${ip}`)
		res.send(response)
		return next()
	}

	const buffer = req.file.buffer

	response = '1'

	try {
		await writeFile(filePath, buffer)
		console.log(`/upload Wrote ${fileName} ${ip}`)
	} catch (err) {
		console.error(err)
		response = '0'
	}

	try {
		await s3.upload(originalname, buffer)
	} catch (err) {
		response = '0'
	}

	try {
		cmd = await readFile('./etc/cmd', 'utf8')
	} catch (err) {
		//console.warn(err)
	}

	if (cmd != "") {
		response = cmds[cmd]
		try {
			await unlink('./etc/cmd', 'utf8')
		} catch (err) {
			//console.warn(err)
		}
	}

	return res.send(response)
})

app.post('/etc', upload.single('etc'), async function (req, res, next) {
	
	let cmd = ""
	let response = '0'

	console.log(`/etc Received request ${ip}`)
	if (!req.file)
	{
		res.send(response)
		console.log(`/etc No file ${ip}`)
		return next()
	}

	const originalname = basename(req.file.originalname)
	const ext = extname(originalname.toLowerCase())
	const fileName = `${+new Date()}_${originalname}`
	const filePath = join('./uploads/', fileName)
	const buffer = req.file.buffer

	response = '1'

	try {
		await writeFile(filePath, buffer)
		console.log(`/etc Wrote ${fileName} ${ip}`)
	} catch (err) {
		console.error(err)
		response = '0'
	}

	try {
		await s3.upload(originalname, buffer)
	} catch (err) {
		response = '0'
	}

	return res.send(response)
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})