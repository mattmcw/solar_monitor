CREATE TABLE IF NOT EXISTS conextstate (
	timestamp_str TEXT PRIMARY KEY,
	timestamp INTEGER,
	volts REAL,
	current REAL,
	temperature INTEGER,
	charge INTEGER
);

CREATE TABLE IF NOT EXISTS conextevents (
	id TEXT PRIMARY KEY,
	timestamp INTEGER,
	message TEXT,
	start INTEGER,
	end INTEGER
)
