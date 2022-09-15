-- 1-7
USE master
GO

IF DB_ID('LaundrySystemDb') IS NOT NULL
BEGIN
    ALTER DATABASE LaundrySystemDb SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE LaundrySystemDb;
END
IF DB_ID('LaundrySystemDb') IS NULL
BEGIN
    CREATE DATABASE LaundrySystemDb;
END
GO

USE LaundrySystemDb
GO

-- 1-7
DROP TABLE IF EXISTS [Laundromat]
IF OBJECT_ID('Laundromat') IS NULL
BEGIN
    CREATE TABLE [Laundromat] (
        [Id] INT IDENTITY(1, 1),
        [Name] NVARCHAR(100),
        [Opens] TIME,
        [Closes] TIME,
        CONSTRAINT PK_Laundromat PRIMARY KEY ([Id])
    );
END
GO

-- 1-7
DROP TABLE IF EXISTS [User]
IF OBJECT_ID('User') IS NULL
BEGIN
    CREATE TABLE [User] (
        [Id] INT IDENTITY(1, 1),
        [Name] NVARCHAR(100),
        [Email] NVARCHAR(255),
        [Password] NVARCHAR(100),
        [Account] DECIMAL(8, 2),
        [LaundromatId] INT NOT NULL,
        [Created] DATE,
        CONSTRAINT CK_User_Password_Min_Length CHECK(LEN([Password]) >= 5),
        CONSTRAINT PK_User PRIMARY KEY ([Id]),
        CONSTRAINT [FK_User.LaundromatId] FOREIGN KEY ([LaundromatId]) REFERENCES [Laundromat]([Id])
    );
END
GO

-- 1-7
DROP TABLE IF EXISTS [Machine]
IF OBJECT_ID('Machine') IS NULL
BEGIN
    CREATE TABLE [Machine] (
        [Id] INT IDENTITY(1, 1),
        [Name] NVARCHAR(100),
        [PricePerWash] DECIMAL(8, 2),
        [WashTimeMinutes] INT,
        [LaundromatId] INT NOT NULL,
        CONSTRAINT PK_Machine PRIMARY KEY ([Id]),
        CONSTRAINT [FK_Machine.LaundromatId] FOREIGN KEY ([LaundromatId]) REFERENCES [Laundromat]([Id])
    );
END
GO

-- 1-7
DROP TABLE IF EXISTS [Booking]
IF OBJECT_ID('Booking') IS NULL
BEGIN
    CREATE TABLE [Booking] (
        [Id] INT IDENTITY(1, 1),
        [TimeOfWash] DATETIME,
        [UserId] INT NOT NULL,
        [MachineId] INT NOT NULL,
        CONSTRAINT PK_Booking PRIMARY KEY ([Id]),
        CONSTRAINT [FK_Booking.UserId] FOREIGN KEY ([UserId]) REFERENCES [User]([Id]),
        CONSTRAINT [FK_Booking.MachineId] FOREIGN KEY ([MachineId]) REFERENCES [Machine]([Id])
    );
END
GO

-- 1-7
INSERT INTO Laundromat ([Name], [Opens], [Closes])
VALUES ('Whitewash Inc.', '08:00', '20:00'), ('Double Bubble', '02:00', '22:00'), ('Wash & Coffee', '12:00', '20:00')
GO

-- 1-7
INSERT INTO [User] ([Name], Email, [Password], Account, LaundromatId, [Created])
VALUES 
    ('John', 'john_doe66@gmail.com', 'password', 100.00, 2, '2021-02-15'),
    ('Neil Armstrong', 'firstman@nasa.gov', 'eagleLander69', 1000.00, 1, '2021-02-10'),
    ('Batman', 'noreply@thecave.com', 'Rob1n', 500.00, 3, '2020-03-10'),
    ('Goldman Sachs', 'moneylaundering@gs.com', 'NotRecognized', 100000.00, 1, '2021-01-01'),
    ('50 Cent', '50cent@gmail.com', 'ItsMyBirthday', 0.50, 3, '2020-07-06')
GO

-- 1-7
INSERT INTO [Machine] ([Name], PricePerWash, WashTimeMinutes, LaundromatId)
VALUES 
    ('Mielle 911 Turbo', 5.00, 60, 2),
    ('Siemons IClean', 10000.00, 30, 1),
    ('Electrolax FX-2', 15.00, 45, 2),
    ('NASA Spacewasher 8000', 500.00, 5, 1),
    ('The Lost Sock', 3.50, 90, 3),
    ('Yo Mama', 0.50, 120, 3)
GO

-- 1-7
INSERT INTO [Booking] (TimeOfWash, UserId, MachineId)
VALUES
    ('2021-02-26 12:00:00', 1, 1),
    ('2021-02-26 16:00:00', 1, 3),
    ('2021-02-26 08:00:00', 2, 4),
    ('2021-02-26 15:00:00', 3, 5),
    ('2021-02-26 20:00:00', 4, 2),
    ('2021-02-26 19:00:00', 4, 2),
    ('2021-02-26 10:00:00', 4, 2),
    ('2021-02-26 16:00:00', 5, 6)
GO

-- 8
BEGIN TRANSACTION T_GS_1
    INSERT INTO [Booking] (TimeOfWash, UserId, MachineId)
    VALUES
        ('2022-09-15 12:00:00', 4, 2)
COMMIT TRANSACTION
GO

-- 9
CREATE VIEW Bookings_View AS
    SELECT b.TimeOfWash, u.[Name] as 'User', m.[Name] as 'Machine', m.PricePerWash
    FROM Booking AS b
    JOIN [User] AS u ON u.Id = b.UserId
    JOIN Machine AS m on M.Id = b.MachineId
GO

-- SELECT * FROM Bookings_View;
-- GO

-- 10.a
SELECT *
FROM [User]
WHERE [Email] LIKE '%@gmail.com%'

-- 10.b
SELECT *
FROM Machine AS m
JOIN Laundromat AS l ON l.Id = m.LaundromatId

-- 10.c
SELECT b.MachineID, m.Name, COUNT(*) AS 'Number of bookings'
FROM Booking AS b
JOIN Machine AS m ON b.MachineId = m.Id
GROUP BY b.MachineId, m.Name;

-- 10.d
DELETE
FROM Booking
WHERE CAST(TimeOfWash AS TIME) BETWEEN '12:00' AND '13:00'

-- 10.e
UPDATE [User]
SET [Password] = 'SelinaKyle'
WHERE [Name] = 'Batman'

-- SELECT * FROM [User]
-- SELECT * FROM [Laundromat]
-- SELECT * FROM [Machine]
-- SELECT * FROM [Booking]
-- GO