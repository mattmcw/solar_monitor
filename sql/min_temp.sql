SELECT MIN(temperature) FROM conextstate 
WHERE 
	timestamp > ( SELECT MAX(timestamp) FROM conextstate ) - 86400;