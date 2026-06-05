-- ===================================================================
-- DATABASE DEVELOPMENT LABORATORY WORK: ESPORTS ACADEMY SYSTEM
-- ===================================================================

-- SECTION 1: DATA DEFINITION LANGUAGE (DDL) - CREATE TABLES
-- 1. Create Academy Table
CREATE TABLE Academy (
    academy_id SERIAL PRIMARY KEY,
    academy_name VARCHAR(100) UNIQUE NOT NULL,
    city VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    founded_date DATE NOT NULL
);

-- 2. Create Coach Table
CREATE TABLE Coach (
    coach_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    hire_date DATE NOT NULL
);

-- 3. Create Team Table
CREATE TABLE Team (
    team_id SERIAL PRIMARY KEY,
    academy_id INT NOT NULL,
    team_name VARCHAR(100) NOT NULL,
    game_title VARCHAR(50) NOT NULL,
    created_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'active',
    FOREIGN KEY (academy_id) REFERENCES Academy(academy_id) ON DELETE CASCADE
);

-- 4. Create Player Table
CREATE TABLE Player (
    player_id SERIAL PRIMARY KEY,
    team_id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    nickname VARCHAR(50) NOT NULL,

    role VARCHAR(30) NOT NULL
    CHECK (
        role IN (
            'IGL',
            'Awper',
            'Carry',
            'Support',
            'Rifler',
            'ADC',
            'Mid',
            'Jungler'
        )
    ),

    join_date DATE NOT NULL,
    birth_date DATE,

    FOREIGN KEY (team_id)
        REFERENCES Team(team_id)
        ON DELETE CASCADE
);

-- 5. Create Tournament Table
CREATE TABLE Tournament (
    tournament_id SERIAL PRIMARY KEY,
    tournament_name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,

    start_date DATE NOT NULL
    CHECK (start_date > DATE '2026-01-01'),

    end_date DATE NOT NULL,

    prize_pool DECIMAL(12,2) NOT NULL
    CHECK (prize_pool >= 0),

    organizer VARCHAR(100) NOT NULL
);
-- 6. Create Training Session Table
CREATE TABLE Training_Session (
    training_id SERIAL PRIMARY KEY,
    team_id INT NOT NULL,
    training_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,

    duration_hours DECIMAL(4,2) NOT NULL
    CHECK (duration_hours > 0),

    focus_area VARCHAR(100) NOT NULL,
    notes VARCHAR(255) NOT NULL,

    FOREIGN KEY (team_id)
        REFERENCES Team(team_id)
        ON DELETE CASCADE
);

-- 7. Create Sponsorship Table
CREATE TABLE Sponsorship (
    sponsorship_id SERIAL PRIMARY KEY,
    team_id INT NOT NULL,
    sponsor_name VARCHAR(100) NOT NULL,

    amount DECIMAL(12,2) NOT NULL
    CHECK (amount >= 0),

    start_date DATE NOT NULL,
    end_date DATE NOT NULL,

    FOREIGN KEY (team_id)
        REFERENCES Team(team_id)
        ON DELETE CASCADE
);

-- 8. Create Coach Academy Junction Table
CREATE TABLE Coach_Academy (
    coach_id INT NOT NULL,
    academy_id INT NOT NULL,
    start_date DATE NOT NULL,
    PRIMARY KEY (coach_id, academy_id),
    FOREIGN KEY (coach_id) REFERENCES Coach(coach_id) ON DELETE CASCADE,
    FOREIGN KEY (academy_id) REFERENCES Academy(academy_id) ON DELETE CASCADE
);

-- 9. Create Coach Training Junction Table
CREATE TABLE Coach_Training (
    coach_id INT NOT NULL,
    training_id INT NOT NULL,
    PRIMARY KEY (coach_id, training_id),
    FOREIGN KEY (coach_id) REFERENCES Coach(coach_id) ON DELETE CASCADE,
    FOREIGN KEY (training_id) REFERENCES Training_Session(training_id) ON DELETE CASCADE
);

-- 10. Create Team Tournament Junction Table
CREATE TABLE Team_Tournament (
    team_tournament_id SERIAL PRIMARY KEY,

    team_id INT NOT NULL,
    tournament_id INT NOT NULL,

    bonus_points INT DEFAULT 0,

    total_points INT
    GENERATED ALWAYS AS
    (COALESCE(bonus_points,0) + 10)
    STORED,

    FOREIGN KEY (team_id)
        REFERENCES Team(team_id)
        ON DELETE CASCADE,

    FOREIGN KEY (tournament_id)
        REFERENCES Tournament(tournament_id)
        ON DELETE CASCADE
);


-- ===================================================================
-- SECTION 2: TABLE MODIFICATIONS (ALTER TABLE)
-- ===================================================================
ALTER TABLE Player ALTER COLUMN role TYPE VARCHAR(50);
ALTER TABLE Academy ADD COLUMN website_url VARCHAR(255);
ALTER TABLE Coach ADD CONSTRAINT uq_coach_full_name UNIQUE (first_name, last_name);
ALTER TABLE Tournament ALTER COLUMN location SET DEFAULT 'Online';
ALTER TABLE Training_Session RENAME COLUMN notes TO session_summary;


-- ===================================================================
-- SECTION 3: DATA MANIPULATION LANGUAGE (DML) - INSERT DATA
-- ===================================================================

-- Insert Records into Academy
INSERT INTO Academy (academy_name, city, country, founded_date, website_url) VALUES
('Saimans Academy', 'Almaty', 'Kazakhstan', '2020-05-15', 'https://saimans.kz'),
('Virtus Academy', 'Astana', 'Kazakhstan', '2021-09-01', 'https://virtus.kz'),
('NaVi Youth', 'Kyiv', 'Ukraine', '2019-11-20', 'https://navi.gg'),
('G2 Rising', 'Berlin', 'Germany', '2022-01-10', 'https://g2esports.com'),
('T1 Base', 'Seoul', 'South Korea', '2018-03-05', 'https://t1.gg');

-- Insert Records into Tournament
INSERT INTO Tournament (tournament_name, location, start_date, end_date, prize_pool, organizer) VALUES
('Almaty Cyber Cup 2026', 'Almaty Arena', '2026-03-01', '2026-03-05', 50000.00, 'PGL'),
('Astana Masters 2026', 'Barys Arena', '2026-06-12', '2026-06-20', 120000.00, 'ESL'),
('Major Kyiv 2026', 'Kyiv Cyberport', '2026-08-15', '2026-08-30', 500000.00, 'Valve'),
('Berlin Invitational 2026', 'Online', '2026-04-10', '2026-04-15', 35000.00, 'G2 Org'),
('Seoul Showdown 2026', 'T1 HQ', '2026-10-01', '2026-10-10', 250000.00, 'KeSPA');

-- Insert Records into Coach
INSERT INTO Coach (first_name, last_name, specialization, hire_date) VALUES
('Ilnur', 'Garifov', 'CS2 Tactics', '2021-06-01'),
('Nurdaulet', 'Zhumabay', 'Dota 2 Strategy', '2022-02-15'),
('Artur', 'Kurmashev', 'Sniper Training', '2023-01-10'),
('Arnur', 'Kamay', 'Rifle Aiming', '2024-05-01'),
('Maksim', 'Lee', 'Midlane Control', '2020-04-01');

-- Insert Records into Team
INSERT INTO Team (academy_id, team_name, game_title, created_date, status) VALUES
((SELECT academy_id FROM Academy WHERE academy_name = 'Saimans Academy'), 'Saimans CS2', 'CS2', '2020-06-01', 'active'),
((SELECT academy_id FROM Academy WHERE academy_name = 'Virtus Academy'), 'Virtus Dota', 'Dota 2', '2021-10-01', 'active'),
((SELECT academy_id FROM Academy WHERE academy_name = 'NaVi Youth'), 'NaVi Junior', 'CS2', '2019-12-01', 'active'),
((SELECT academy_id FROM Academy WHERE academy_name = 'G2 Rising'), 'G2 Academy', 'League of Legends', '2022-02-01', 'active'),
((SELECT academy_id FROM Academy WHERE academy_name = 'T1 Base'), 'T1 Challengers', 'League of Legends', '2018-04-01', 'active');

-- Insert Records into Player
INSERT INTO Player (team_id, first_name, last_name, nickname, role, join_date, birth_date) VALUES
((SELECT team_id FROM Team WHERE team_name = 'Saimans CS2'), 'Daurenbek', 'Tabyldy', 'HObbit_Jr', 'IGL', '2022-01-15', '2005-04-12'),
((SELECT team_id FROM Team WHERE team_name = 'Saimans CS2'), 'Aisha', 'Zhumagali', 'fitch_pro', 'Awper', '2023-03-20', '2006-08-22'),
((SELECT team_id FROM Team WHERE team_name = 'Virtus Dota'), 'Aktoty', 'Shakhmet', 'TA2000_Fan', 'Carry', '2022-11-01', '2004-11-15'),
((SELECT team_id FROM Team WHERE team_name = 'Virtus Dota'), 'Diana', 'Chigrina', 'sayuw_kid', 'Support', '2023-05-14', '2005-01-30'),
((SELECT team_id FROM Team WHERE team_name = 'NaVi Junior'), 'Symbat', 'Kadyrgali', 'm0NESY_clone', 'Awper', '2021-02-10', '2005-05-01'),
((SELECT team_id FROM Team WHERE team_name = 'NaVi Junior'), 'Saida', 'Tauman', 'b1t_son', 'Rifler', '2021-05-12', '2004-09-18'),
((SELECT team_id FROM Team WHERE team_name = 'G2 Academy'), 'Korkem', 'Igilik', 'Rekkles_Fan', 'ADC', '2023-01-05', '2003-12-05'),
((SELECT team_id FROM Team WHERE team_name = 'G2 Academy'), 'Asylay', 'Zhumakulova', 'Caps_Junior', 'Mid', '2023-06-11', '2005-07-07'),
((SELECT team_id FROM Team WHERE team_name = 'T1 Challengers'), 'Aiken', 'Amanbay', 'Keria_Boy', 'Support', '2022-08-19', '2006-02-14'),
((SELECT team_id FROM Team WHERE team_name = 'T1 Challengers'), 'Moldir', 'Olzhabayeva', 'Oner_Light', 'Jungler', '2022-09-01', '2005-10-24');

-- Insert Records into Training Session
INSERT INTO Training_Session (team_id, training_date, start_time, end_time, duration_hours, focus_area, session_summary) VALUES
((SELECT team_id FROM Team WHERE team_name = 'Saimans CS2'), '2026-02-01', '10:00:00', '14:00:00', 4.00, 'Mirage Smokes', 'Practiced A site executes'),
((SELECT team_id FROM Team WHERE team_name = 'Saimans CS2'), '2026-02-02', '15:00:00', '18:00:00', 3.00, 'Aim Retake', 'Retake simulations on Inferno'),
((SELECT team_id FROM Team WHERE team_name = 'Virtus Dota'), '2026-02-03', '11:00:00', '15:00:00', 4.00, 'Roshan Fight', 'Drafting around Roshan advantage'),
((SELECT team_id FROM Team WHERE team_name = 'Virtus Dota'), '2026-02-04', '14:00:00', '17:00:00', 3.00, 'Late Game Ward', 'Support vision placement control'),
((SELECT team_id FROM Team WHERE team_name = 'NaVi Junior'), '2026-02-05', '09:00:00', '14:00:00', 5.00, 'AWP Crosshair', 'Flick shots and positioning'),
((SELECT team_id FROM Team WHERE team_name = 'NaVi Junior'), '2026-02-06', '13:00:00', '16:00:00', 3.00, 'Eco Rounds', 'Deagle optimization and spacing'),
((SELECT team_id FROM Team WHERE team_name = 'G2 Academy'), '2026-02-07', '12:00:00', '16:00:00', 4.00, 'Draft Phase', 'Counter-picking enemy midlane'),
((SELECT team_id FROM Team WHERE team_name = 'G2 Academy'), '2026-02-08', '16:00:00', '19:00:00', 3.00, 'Baron Setup', 'Vision denial around Baron pit'),
((SELECT team_id FROM Team WHERE team_name = 'T1 Challengers'), '2026-02-09', '10:00:00', '15:00:00', 5.00, 'Macro Mechanics', 'Map movement and lane assignment'),
((SELECT team_id FROM Team WHERE team_name = 'T1 Challengers'), '2026-02-10', '14:00:00', '18:00:00', 4.00, 'Teamfights', '5v5 positioning in dragon fights');

-- Insert Records into Sponsorship
INSERT INTO Sponsorship (team_id, sponsor_name, amount, start_date, end_date) VALUES
((SELECT team_id FROM Team WHERE team_name = 'Saimans CS2'), '1XBET', 60000.00, '2026-01-01', '2026-12-31'),
((SELECT team_id FROM Team WHERE team_name = 'Virtus Dota'), 'RedBull', 120000.00, '2026-01-01', '2026-12-31'),
((SELECT team_id FROM Team WHERE team_name = 'NaVi Junior'), 'LogitechG', 84000.00, '2026-01-01', '2026-12-31'),
((SELECT team_id FROM Team WHERE team_name = 'G2 Academy'), 'Monster Energy', 96000.00, '2026-01-01', '2026-12-31'),
((SELECT team_id FROM Team WHERE team_name = 'T1 Challengers'), 'SK Telecom', 240000.00, '2026-01-01', '2026-12-31');

-- Insert Records into Team Tournament Junction Table
INSERT INTO Team_Tournament (team_id, tournament_id, bonus_points) VALUES
((SELECT team_id FROM Team WHERE team_name = 'Saimans CS2'), (SELECT tournament_id FROM Tournament WHERE tournament_name = 'Almaty Cyber Cup 2026'), 5),
((SELECT team_id FROM Team WHERE team_name = 'Virtus Dota'), (SELECT tournament_id FROM Tournament WHERE tournament_name = 'Almaty Cyber Cup 2026'), 15);


-- ===================================================================
-- SECTION 4: DATA UPDATE AND DELETION WITH TRANSACTION CONTROL
-- ===================================================================
UPDATE Team 
SET status = 'inactive' 
WHERE team_name = 'G2 Academy';

UPDATE Sponsorship s
SET amount = s.amount * 1.15
FROM Team t
WHERE s.team_id = t.team_id AND s.sponsor_name = 'RedBull';

BEGIN;
DELETE FROM Tournament WHERE prize_pool < 40000.00;
ROLLBACK;


-- ===================================================================
-- SECTION 5: DATA CONTROL LANGUAGE (DCL)
-- ===================================================================
-- Granting object permissions directly
GRANT SELECT ON ALL TABLES IN SCHEMA public TO esports_readonly;
GRANT INSERT, UPDATE ON Player TO esports_writer;
REVOKE UPDATE ON Player FROM esports_writer;