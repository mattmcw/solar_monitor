CREATE TABLE IF NOT EXISTS conextstate (
	timestamp_str VARCHAR PRIMARY KEY,
	timestamp INTEGER,
	volts REAL,
	current REAL,
	temperature REAL,
	charge INTEGER
);
