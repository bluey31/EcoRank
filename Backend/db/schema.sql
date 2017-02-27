CREATE TABLE IF NOT EXISTS Users (
    userId INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
    username TEXT UNIQUE,
    password TEXT,
    energyConsumtion REAL,
    longitude REAL,
    latutude REAL,
    houseClassifier INTEGER
);
CREATE TABLE IF NOT EXISTS Devices (
    deviceId INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
    deviceName TEXT,
    wattUsagePerHour REAL
);
CREATE TABLE IF NOT EXISTS EnergyConsumption(
    energyLogID INTEGER PRIMARY KEY UNIQUE,
    userId INTEGER
        REFERENCES Users(userId) on delete cascade on update cascade,
    day NUMERIC,
    energyUsed REAL
);
CREATE TABLE IF NOT EXISTS Sessions(
    userId INTEGER
        REFERENCES Users(userId) on delete cascade on update cascade,
    token TEXT,
    expiry INTEGER
);
CREATE TABLE IF NOT EXISTS UserDevices(
    userId INTEGER
        REFERENCES Users(userId) on delete cascade on update cascade,
    deviceId INTEGER
        REFERENCES Devices(deviceId) on delete cascade on update cascade,
    count INTEGER
);


