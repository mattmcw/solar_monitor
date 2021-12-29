SELECT ROUND(AVG(temperature)) FROM conextstate 
WHERE 
	timestamp > ( SELECT MAX(timestamp) FROM conextstate ) - 86400;