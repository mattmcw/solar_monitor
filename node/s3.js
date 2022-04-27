'use strict';

const { Endpoint, S3 } = require('aws-sdk')
const { join } = require('path')

const S3_ACCESS_KEY = 		process.env.S3_ACCESS_KEY 		|| 'YOUR-ACCESSKEYID'
const S3_ACCESS_SECRET = 	process.env.S3_ACCESS_SECRET 	|| 'YOUR-SECRETACCESSKEY'
const S3_ENDPOINT = 		process.env.S3_ENDPOINT 		|| 'http://127.0.0.1:9000'
const S3_BUCKET =   		process.env.S3_BUCKET           || 'bucket'

const spacesEndpoint = new Endpoint(S3_ENDPOINT)
const s3Config = {
	accessKeyId:  S3_ACCESS_KEY,
	secretAccessKey:  S3_ACCESS_SECRET,
	endpoint: spacesEndpoint,
	signatureVersion: 'v4'
}
const s3  = new S3(s3Config)

async function upload (filename, buffer) {
	const key = join('PondIsland/solar/', filename)
	const params = {
		Bucket: S3_BUCKET, 
		Key: key, 
		Body: buffer
	}
	console.log(`S3 Uploading ${key}...`)
	return new Promise((resolve, reject) => {
		return s3.putObject(params, function (err, data) {
			if (err) {
				console.error(err)
				return reject(err)
			} else  {
				console.log(`S3 Uploaded ${key}`)
				return resolve(true)
			}
		})
	})
}

module.exports = { upload }