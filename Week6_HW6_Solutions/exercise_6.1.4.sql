-- Exercise 6.1.4 Write the following queries based on the database schema below:

-- Classes (class, type, country, numGuns, bore, displacement
-- Ships (name, class, launched)
-- Battles (name, data)
-- Outcomes (ship, battle, result)

-- a) Find the class name and country for all classes with at least 10 guns.
SELECT class, country
FROM Classes
WHERE numGuns >= 10;

-- b) Find the names of all ships launched prior to 1918, but call the resulting column shipName.
SELECT name as shipName
FROM Ships
WHERE launched < 1918;

-- c) Find the names of ships sunk in battle and the name of the battle in which they were sunk.
SELECT ship, battle
FROM Outcomes
WHERE result = 'sunk';

-- d) Find all ships that have the same name as their class.
SELECT name
FROM Ships
WHERE name = class;

-- e) Find the names of all ships that begin with the letter "R".
SELECT name
FROM Ships
WHERE name LIKE 'R%';
-- Note: To retrieve all ships a UNION of Ships and Outcomes is required:
SELECT name
FROM Ships
WHERE name LIKE 'R%'

UNION

SELECT ship
FROM Outcomes
WHERE ship LIKE 'R%';

-- f) Find the names of all ships whose name consists of three or more words (e.g., King George V).
SELECT name
FROM Ships
WHERE name LIKE '_% _% _%';
-- Note: As in (e), UNION with results from Outcomes.
SELECT name
FROM Ships
WHERE name LIKE '_% _% _%'

UNION

SELECT ship
FROM Outcomes
WHERE ship LIKE '_% _% _%';