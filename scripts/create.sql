--------------------------------------------------------------------
-----------------------Working with schema--------------------------
--------------------------------------------------------------------

-- Drop Schema
DROP SCHEMA IF EXISTS tennis CASCADE;

-- Create Schema
CREATE SCHEMA IF NOT EXISTS tennis;

--------------------------------------------------------------------
--------------------------Creating Tables---------------------------
--------------------------------------------------------------------

-- Player Table
CREATE TABLE IF NOT EXISTS tennis.Player
(
    Player_Id        SERIAL PRIMARY KEY,
    Full_Name        VARCHAR(100),
    Age              INT,
    Country          VARCHAR(50),
    Plays            VARCHAR(50),
    Prize_Money      INT,
    Career_High_Rank INT,
    Weight           INT,
    Turned_Pro       DATE
);

-- Player_Statistics Table
CREATE TABLE IF NOT EXISTS tennis.Player_Statistics
(
    Player_Id           INT PRIMARY KEY,
    Aces                INT,
    Double_Faults       INT,
    First_Serve         FLOAT,
    Return_Games_Played INT,
    Return_Games_Won    INT,
    Serve_Games_Played  INT,
    Serve_Games_Won     INT,
    FOREIGN KEY (Player_Id) REFERENCES tennis.Player (Player_Id)
);

-- Player Ranking History Table
CREATE TABLE IF NOT EXISTS tennis.Player_Ranking_History
(
    Player_Id INT,
    Ranking   INT,
    From_Date DATE,
    Till_Date DATE,
    PRIMARY KEY (Player_Id, From_Date),
    FOREIGN KEY (Player_Id) REFERENCES tennis.Player (Player_Id)
);

-- Tournament Table
CREATE TABLE IF NOT EXISTS tennis.Tournament
(
    Tournament_Id   SERIAL PRIMARY KEY,
    Tournament_Name VARCHAR(100),
    Surface         VARCHAR(50),
    Location        VARCHAR(100),
    Prize           INT,
    Num_Matches     INT
);

-- Official Points Table
CREATE TABLE IF NOT EXISTS tennis.Official_Points
(
    Tournament_ID   INT REFERENCES tennis.Tournament,
    Place           INT,
    Player_ID       INT REFERENCES tennis.Player,
    Official_Points INT,
    PRIMARY KEY (Place, Tournament_ID)
);

-- Atp Ranking Table
CREATE TABLE IF NOT EXISTS tennis.Atp_Ranking
(
    Player_Id       INT PRIMARY KEY,
    Ranking         INT,
    Official_Points INT,
    FOREIGN KEY (Player_Id) REFERENCES tennis.Player (Player_Id)
);

-- Match Table
CREATE TABLE IF NOT EXISTS tennis.Match
(
    Match_Id      SERIAL PRIMARY KEY,
    Tournament_Id INT REFERENCES tennis.Tournament,
    Winner_ID     INT,
    Other_ID      INT,
    Begin_Date    DATE,
    End_Date      DATE,
    FOREIGN KEY (Winner_ID) REFERENCES tennis.Player (Player_Id),
    FOREIGN KEY (Other_ID) REFERENCES tennis.Player (Player_Id)
);

-- Match Statistics Table
CREATE TABLE IF NOT EXISTS tennis.Match_Statistics
(
    Match_Id          INT PRIMARY KEY,
    Duration          TIME,
    First_Set_Winner  INT,
    First_Set_Other   INT,
    Second_Set_Winner INT,
    Second_Set_Other  INT,
    Third_Set_Winner  INT,
    Third_Set_Other   INT,
    FOREIGN KEY (Match_Id) REFERENCES tennis.Match (Match_Id)
);

--------------------------------------------------------------------
----------------------------Filling Data----------------------------
--------------------------------------------------------------------

-- Inserting additional sample data into the Player Table
INSERT INTO tennis.Player (Full_Name, Age, Country, Plays, Prize_Money, Career_High_Rank, Weight, Turned_Pro)
VALUES ('Novak Djokovic', 34, 'Serbia', 'Right-Handed', 155349924, 1, 77, '2003-07-01'),
       ('Roger Federer', 40, 'Switzerland', 'Right-Handed', 130205890, 1, 85, '1998-01-01'),
       ('Rafael Nadal', 35, 'Spain', 'Left-Handed', 124935404, 1, 85, '2001-04-01'),
       ('Stefanos Tsitsipas', 23, 'Greece', 'Right-Handed', 19803788, 3, 84, '2016-05-01'),
       ('Alexander Zverev', 24, 'Germany', 'Right-Handed', 27901923, 3, 90, '2013-01-01'),
       ('Dominic Thiem', 28, 'Austria', 'Right-Handed', 28794312, 3, 82, '2011-09-01'),
       ('Andrey Rublev', 24, 'Russia', 'Right-Handed', 6249032, 5, 75, '2014-07-01'),
       ('Cameron Norrie', 26, 'United Kingdom', 'Left-Handed', 2573114, 16, 74, '2017-07-01'),
       ('Aslan Karatsev', 28, 'Russia', 'Right-Handed', 2319263, 14, 80, '2007-07-01'),
       ('Diego Schwartzman', 29, 'Argentina', 'Right-Handed', 13088655, 8, 67, '2010-04-01'),
       ('Jannik Sinner', 20, 'Italy', 'Right-Handed', 2975092, 8, 81, '2018-08-01'),
       ('Felix Auger-Aliassime', 21, 'Canada', 'Right-Handed', 5960484, 10, 88, '2017-09-01'),
       ('Gael Monfils', 35, 'France', 'Right-Handed', 18455955, 6, 80, '2004-03-01'),
       ('Nick Kyrgios', 26, 'Australia', 'Right-Handed', 8606444, 13, 80, '2013-06-01'),
       ('Fabio Fognini', 34, 'Italy', 'Right-Handed', 11828064, 9, 74, '2004-01-01');

-- Inserting additional sample data into the Player_Statistics Table
INSERT INTO tennis.Player_Statistics (Player_Id, Aces, Double_Faults, First_Serve, Return_Games_Played,
                                      Return_Games_Won, Serve_Games_Played, Serve_Games_Won)
VALUES (1, 452, 120, 63, 205, 120, 190, 150),
       (2, 315, 155, 60, 180, 110, 170, 145),
       (3, 265, 90, 65, 200, 130, 195, 155),
       (4, 200, 80, 62, 175, 100, 160, 135),
       (5, 205, 95, 65, 190, 125, 180, 140),
       (6, 155, 110, 59, 185, 115, 175, 130),
       (7, 140, 80, 61, 170, 105, 165, 125),
       (8, 120, 70, 59, 160, 95, 155, 120),
       (9, 180, 85, 61, 165, 100, 160, 125),
       (10, 195, 105, 64, 175, 110, 170, 135),
       (11, 220, 95, 62, 180, 120, 175, 140),
       (12, 190, 75, 60, 170, 115, 165, 130),
       (13, 210, 100, 63, 185, 125, 180, 145),
       (14, 175, 80, 60, 170, 105, 165, 125),
       (15, 225, 110, 65, 190, 130, 180, 145);

-- Inserting additional sample data into the Player_Ranking_History Table
INSERT INTO tennis.Player_Ranking_History (Player_Id, Ranking, From_Date, Till_Date)
VALUES (1, 1, '2021-01-01', '2021-12-31'),
       (1, 1, '2020-01-01', '2020-12-31'),
       (1, 1, '2019-01-01', '2019-12-31'),
       (2, 3, '2021-01-01', '2021-12-31'),
       (2, 4, '2020-01-01', '2020-12-31'),
       (2, 3, '2019-01-01', '2019-12-31'),
       (3, 2, '2021-01-01', '2021-12-31'),
       (3, 2, '2020-01-01', '2020-12-31'),
       (3, 1, '2019-01-01', '2019-12-31'),
       (4, 4, '2021-01-01', '2021-12-31'),
       (4, 5, '2020-01-01', '2020-12-31'),
       (4, 6, '2019-01-01', '2019-12-31'),
       (5, 3, '2021-01-01', '2021-12-31'),
       (5, 7, '2020-01-01', '2020-12-31'),
       (5, 4, '2019-01-01', '2019-12-31'),
       (6, 4, '2021-01-01', '2021-12-31'),
       (6, 3, '2020-01-01', '2020-12-31'),
       (6, 4, '2019-01-01', '2019-12-31'),
       (7, 8, '2021-01-01', '2021-12-31'),
       (7, 9, '2020-01-01', '2020-12-31'),
       (7, 22, '2019-01-01', '2019-12-31'),
       (8, 12, '2021-01-01', '2021-12-31'),
       (8, 53, '2020-01-01', '2020-12-31'),
       (8, 66, '2019-01-01', '2019-12-31'),
       (9, 25, '2021-01-01', '2021-12-31'),
       (9, 111, '2020-01-01', '2020-12-31'),
       (9, 254, '2019-01-01', '2019-12-31'),
       (10, 15, '2021-01-01', '2021-12-31'),
       (10, 13, '2020-01-01', '2020-12-31'),
       (10, 14, '2019-01-01', '2019-12-31'),
       (11, 20, '2021-01-01', '2021-12-31'),
       (11, 37, '2020-01-01', '2020-12-31'),
       (11, 78, '2019-01-01', '2019-12-31'),
       (12, 11, '2021-01-01', '2021-12-31'),
       (12, 21, '2020-01-01', '2020-12-31'),
       (12, 22, '2019-01-01', '2019-12-31'),
       (13, 17, '2021-01-01', '2021-12-31'),
       (13, 9, '2020-01-01', '2020-12-31'),
       (13, 38, '2019-01-01', '2019-12-31'),
       (14, 45, '2021-01-01', '2021-12-31'),
       (14, 46, '2020-01-01', '2020-12-31'),
       (14, 51, '2019-01-01', '2019-12-31'),
       (15, 18, '2021-01-01', '2021-12-31'),
       (15, 11, '2020-01-01', '2020-12-31'),
       (15, 13, '2019-01-01', '2019-12-31');

-- Inserting additional sample data into the Tournament Table
INSERT INTO tennis.Tournament (Tournament_Name, Surface, Location, Prize, Num_Matches)
VALUES ('Australian Open', 'Hard', 'Melbourne', 2000000, 127),
       ('French Open', 'Clay', 'Paris', 1500000, 127),
       ('Wimbledon', 'Grass', 'London', 2000000, 127),
       ('US Open', 'Hard', 'New York', 2500000, 127),
       ('ATP Finals', 'Hard', 'Various', 1500000, 15),
       ('Miami Open', 'Hard', 'Miami', 1000000, 127),
       ('Monte Carlo Masters', 'Clay', 'Monte Carlo', 1000000, 63),
       ('Indian Wells Masters', 'Hard', 'Indian Wells', 1000000, 63),
       ('Madrid Open', 'Clay', 'Madrid', 1000000, 63),
       ('Rome Masters', 'Clay', 'Rome', 1000000, 63),
       ('Cincinnati Masters', 'Hard', 'Cincinnati', 1000000, 63),
       ('Shanghai Masters', 'Hard', 'Shanghai', 1000000, 63),
       ('Paris Masters', 'Hard', 'Paris', 1000000, 63),
       ('Acapulco Open', 'Hard', 'Acapulco', 500000, 63),
       ('Vienna Open', 'Hard', 'Vienna', 500000, 63),
       ('Hamburg Open', 'Clay', 'Hamburg', 500000, 63),
       ('St. Petersburg Open', 'Hard', 'St. Petersburg', 500000, 63),
       ('Moscow Open', 'Hard', 'Moscow', 500000, 63),
       ('Antwerp Open', 'Hard', 'Antwerp', 500000, 63),
       ('Dubai Open', 'Hard', 'Dubai', 500000, 63),
       ('Stockholm Open', 'Hard', 'Stockholm', 500000, 63),
       ('Marseille Open', 'Hard', 'Marseille', 500000, 63),
       ('Los Cabos Open', 'Hard', 'Los Cabos', 500000, 63);

-- Inserting additional sample data into the Match Table
INSERT INTO tennis.Match (Tournament_Id, Winner_ID, Other_ID, Begin_Date, End_Date)
VALUES (1, 1, 2, '2021-01-18', '2021-01-20'),
       (1, 3, 4, '2021-01-19', '2021-01-21'),
       (1, 5, 6, '2021-01-22', '2021-01-24'),
       (2, 6, 3, '2021-05-24', '2021-05-26'),
       (2, 2, 14, '2021-05-25', '2021-05-27'),
       (3, 1, 4, '2021-06-28', '2021-06-30'),
       (3, 13, 2, '2021-06-29', '2021-07-01'),
       (4, 2, 12, '2021-08-30', '2021-09-01'),
       (4, 4, 7, '2021-08-31', '2021-09-02'),
       (5, 1, 8, '2021-11-14', '2021-11-16'),
       (5, 4, 8, '2021-11-15', '2021-11-17'),
       (6, 1, 3, '2021-03-24', '2021-03-26'),
       (6, 2, 12, '2021-03-25', '2021-03-27'),
       (7, 3, 2, '2021-04-11', '2021-04-13'),
       (7, 4, 13, '2021-04-12', '2021-04-14'),
       (8, 14, 4, '2021-10-11', '2021-10-13'),
       (8, 7, 3, '2021-10-12', '2021-10-14'),
       (9, 4, 8, '2021-05-02', '2021-05-04'),
       (9, 7, 3, '2021-05-03', '2021-05-05'),
       (10, 1, 15, '2021-05-09', '2021-05-11'),
       (10, 3, 15, '2021-05-10', '2021-05-12'),
       (11, 11, 5, '2021-08-15', '2021-08-17'),
       (11, 1, 15, '2021-08-16', '2021-08-18'),
       (12, 7, 4, '2021-10-10', '2021-10-12'),
       (12, 3, 9, '2021-10-11', '2021-10-13'),
       (13, 2, 9, '2021-11-07', '2021-11-09'),
       (13, 1, 12, '2021-11-08', '2021-11-10'),
       (14, 7, 1, '2021-02-22', '2021-02-24'),
       (14, 4, 3, '2021-02-23', '2021-02-25'),
       (15, 3, 4, '2021-10-25', '2021-10-27'),
       (15, 1, 10, '2021-10-26', '2021-10-28'),
       (16, 9, 1, '2021-07-12', '2021-07-14'),
       (16, 7, 4, '2021-07-13', '2021-07-15'),
       (17, 6, 2, '2021-09-27', '2021-09-29'),
       (17, 1, 10, '2021-09-28', '2021-09-30'),
       (18, 1, 4, '2021-10-18', '2021-10-20'),
       (18, 3, 2, '2021-10-19', '2021-10-21'),
       (19, 4, 2, '2021-10-24', '2021-10-26'),
       (19, 1, 15, '2021-10-25', '2021-10-27'),
       (20, 1, 2, '2021-03-13', '2021-03-15'),
       (20, 5, 4, '2021-03-14', '2021-03-16'),
       (21, 4, 3, '2021-11-08', '2021-11-10'),
       (21, 1, 2, '2021-11-09', '2021-11-11'),
       (22, 1, 4, '2021-03-07', '2021-03-09'),
       (22, 10, 3, '2021-03-08', '2021-03-10'),
       (23, 3, 6, '2021-07-19', '2021-07-21'),
       (23, 11, 4, '2021-07-20', '2021-07-22');

-- Inserting additional sample data into the Match Statistics Table
INSERT INTO tennis.Match_Statistics (Match_Id, Duration, First_Set_Winner, First_Set_Other,
                                     Second_Set_Winner, Second_Set_Other, Third_Set_Winner, Third_Set_Other)
VALUES (1, '2:15', 6, 4, 7, 6, 0, 0),
       (2, '1:45', 7, 5, 6, 4, 0, 0),
       (3, '2:30', 6, 7, 7, 5, 6, 4),
       (4, '1:25', 6, 3, 7, 5, 0, 0),
       (5, '2:10', 7, 6, 4, 6, 7, 5),
       (6, '1:40', 6, 4, 7, 6, 0, 0),
       (7, '2:20', 7, 6, 4, 6, 7, 5),
       (8, '1:35', 7, 5, 6, 4, 0, 0),
       (9, '2:25', 6, 7, 7, 5, 6, 4),
       (10, '1:30', 6, 3, 7, 5, 0, 0),
       (11, '2:05', 7, 6, 4, 6, 7, 5),
       (12, '1:50', 6, 4, 7, 6, 0, 0),
       (13, '2:15', 7, 5, 6, 4, 0, 0),
       (14, '1:55', 6, 7, 7, 5, 6, 4),
       (15, '2:30', 6, 3, 7, 5, 0, 0),
       (16, '1:45', 7, 6, 4, 6, 7, 5),
       (17, '2:20', 6, 4, 7, 6, 0, 0),
       (18, '1:40', 7, 5, 6, 4, 0, 0),
       (19, '2:25', 6, 7, 7, 5, 6, 4),
       (20, '1:50', 6, 6, 4, 6, 0, 0),
       (21, '2:10', 7, 6, 7, 5, 6, 4),
       (22, '1:55', 6, 4, 7, 6, 0, 0),
       (23, '2:15', 7, 5, 6, 4, 0, 0),
       (24, '1:35', 6, 7, 7, 5, 6, 4),
       (25, '2:30', 6, 4, 7, 5, 0, 0),
       (26, '1:45', 7, 6, 4, 6, 7, 5),
       (27, '2:20', 6, 4, 7, 6, 0, 0),
       (28, '1:30', 7, 5, 6, 4, 0, 0),
       (29, '2:25', 6, 7, 7, 5, 6, 4),
       (30, '1:50', 6, 3, 7, 5, 0, 0),
       (31, '2:05', 7, 6, 4, 6, 7, 5),
       (32, '1:40', 6, 4, 7, 6, 0, 0),
       (33, '2:15', 7, 5, 6, 4, 0, 0),
       (34, '1:55', 6, 7, 7, 5, 6, 4),
       (35, '2:30', 6, 3, 7, 5, 0, 0),
       (36, '1:45', 7, 6, 4, 6, 7, 5),
       (37, '2:20', 6, 4, 7, 6, 0, 0),
       (38, '1:35', 7, 5, 6, 4, 0, 0),
       (39, '2:25', 6, 7, 7, 5, 6, 4),
       (40, '1:50', 6, 3, 7, 5, 0, 0),
       (41, '2:10', 7, 6, 7, 5, 6, 4),
       (42, '1:55', 6, 4, 7, 6, 0, 0),
       (43, '2:15', 7, 5, 6, 4, 0, 0),
       (44, '1:35', 6, 7, 7, 5, 6, 4),
       (45, '2:30', 6, 4, 7, 5, 0, 0),
       (46, '1:45', 7, 6, 4, 6, 7, 5),
       (47, '2:20', 6, 4, 7, 6, 0, 0);

-- Inserting additional sample data into the Official_Points Table
INSERT INTO tennis.Official_Points (tournament_id, place, player_id, official_points)
VALUES (1, 1, 1, 2000),
       (1, 2, 2, 1000),
       (2, 1, 8, 1000),
       (2, 2, 3, 500),
       (3, 1, 1, 2000),
       (3, 2, 3, 1000),
       (4, 1, 1, 2000),
       (4, 2, 6, 1000),
       (5, 1, 14, 800),
       (5, 2, 1, 400),
       (6, 1, 2, 1000),
       (6, 2, 1, 500),
       (7, 1, 1, 400),
       (7, 2, 4, 200),
       (8, 1, 6, 700),
       (8, 2, 5, 350),
       (9, 1, 3, 600),
       (9, 2, 15, 300),
       (10, 1, 13, 1200),
       (10, 2, 2, 600),
       (11, 1, 6, 1300),
       (11, 2, 3, 650),
       (12, 1, 1, 750),
       (12, 2, 4, 375),
       (13, 1, 4, 800),
       (13, 2, 1, 400),
       (14, 1, 2, 600),
       (14, 2, 1, 300),
       (15, 1, 1, 700),
       (15, 2, 3, 350),
       (16, 1, 10, 1200),
       (16, 2, 2, 600),
       (17, 1, 5, 300),
       (17, 2, 1, 150),
       (18, 1, 5, 500),
       (18, 2, 2, 250),
       (19, 1, 1, 400),
       (19, 2, 3, 200),
       (20, 1, 1, 700),
       (20, 2, 1, 350),
       (21, 1, 1, 400),
       (21, 2, 2, 200),
       (22, 1, 1, 350),
       (22, 2, 1, 175),
       (23, 1, 2, 500),
       (23, 2, 1, 250);

-- Inserting additional sample data into the Atp_Rating Table
INSERT INTO tennis.Atp_Ranking (player_id, ranking, official_points)
VALUES (1, 1, 9800),
       (2, 2, 7789),
       (3, 3, 7590),
       (4, 4, 6389),
       (5, 5, 5830),
       (6, 6, 5290),
       (7, 7, 4629),
       (8, 8, 4619),
       (9, 9, 4589),
       (10, 10, 4290),
       (11, 11, 3958),
       (12, 12, 3490),
       (13, 13, 2890),
       (14, 14, 2679),
       (15, 15, 2230);