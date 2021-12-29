SELECT MIN(timestamp), timestamp_str FROM conextstate 
WHERE 
	timestamp > (SELECT MAX(timestamp) FROM conextstate) - (86400 * 10)
	AND (
		(volts = 0 AND current = 0 AND temperature = 0 AND charge = 0) 
		OR (volts IS NULL AND current IS NULL AND temperature IS NULL AND charge IS NULL ) 
	) 
ORDER BY timestamp DESC;