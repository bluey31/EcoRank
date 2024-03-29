PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS Users (
    userId INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
    username TEXT UNIQUE,
    password TEXT,
    salt TEXT,
    longitude REAL,
    latitude REAL,
    houseClassifier INTEGER
);
CREATE TABLE IF NOT EXISTS Devices (
    deviceId INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
    deviceName TEXT,
    wattUsagePerHour REAL
);
CREATE TABLE IF NOT EXISTS EnergyConsumption(
    userId INTEGER
        REFERENCES Users(userId) on delete cascade on update cascade,
    day NUMERIC,
    energyUsed REAL,
    UNIQUE (userId, day) on conflict replace
);
CREATE TABLE IF NOT EXISTS Sessions(
    userId INTEGER
        REFERENCES Users(userId) on delete cascade on update cascade,
    token TEXT
);
CREATE TABLE IF NOT EXISTS UserDevices(
    userId INTEGER
        REFERENCES Users(userId) on delete cascade on update cascade,
    deviceId INTEGER
        REFERENCES Devices(deviceId) on delete cascade on update cascade,
    count INTEGER
);


