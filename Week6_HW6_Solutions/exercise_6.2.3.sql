-- Exercise 6.2.3 Write the following queries based on the database schema below:

-- Classes (class, type, country, numGuns, bore, displacement)
-- Ships (name, class, launched)
-- Battles (name, date)
-- Outcomes (ship, battle, result)

-- a) Find the ships heavier than 35,000 tons.
SELECT name
FROM Ships
WHERE class IN
	(SELECT class
	 FROM Classes
	 WHERE displacement > 35000);
-- OR
SELECT S.name
FROM Ships S
WHERE EXISTS
	(SELECT 1
     FROM Classes C
	 WHERE S.class = C.class
       AND C.displacement > 35000);
-- OR
SELECT name
FROM Ships S, Classes C
WHERE S.class = C.class
  AND C.displacement > 35000;
-- OR
SELECT name
FROM Ships S, Classes C
JOIN Classes C ON S.class
WHERE C.displacement > 35000;
               
-- b) List the name, displacement and number of guns of the ships engaged in the battle of Guadalcanal.
SELECT S.name, C.displacement, C.numGuns
FROM Ships S, Classes C
WHERE S.class = C.class
  AND S.name IN
	(SELECT ship
	 FROM Outcomes
	 WHERE battle = 'Guadalcanal');
-- OR
SELECT S.name, C.displacement, C.numGuns
FROM Ships S
JOIN Classes C ON S.class = C.class
JOIN Outcomes O ON S.name = O.name
WHERE O.battle = 'Guadalcanal';
                
-- c) List all the ships mentioned in the database. (Remember that all these ships may not appear in the Ships relation.)
SELECT name FROM Ships
UNION
SELECT ship FROM Outcomes;

-- !d) Find those countries that have both battleships and battlecruisers.
SELECT DISTINCT country
FROM Classes
WHERE type = "battleship"
  AND country IN
	(SELECT country
	 FROM Classes
	 WHERE type = "battlecruiser");
-- OR
SELECT DISTINCT C1.country
FROM Country C1
WHERE C1.type = 'battleship'
  AND EXISTS (
      SELECT 1
      FROM Country C2
      WHERE C2.type = 'battlecruiser'
      AND C2.country = C1.country);
-- OR
SELECT C1.Country
FROM Country C1, Country C2
WHERE C1.class = C2. class
  AND C1.type = 'battleship'
  AND C2.type = 'battlecruiser';
-- OR
SELECT C1.country
FROM Country C1
JOIN Country C2 ON C1.country = C2.country
WHERE C1.type = 'battleship'
  AND C2.type = 'battlecruiser';
      
-- !e) Find those ships that were damaged in one battle, but later fought in another.
SELECT O1.ship
FROM Outcomes O1, Battles B1
WHERE result = 'damaged'
  AND O1.battle = B1.name 
  AND EXISTS
	(SELECT B2.date
	 FROM Battles B2, Outcomes O2
	 WHERE O2.battle = B2.name
	   AND O1.ship = O2.ship
	   AND B1.date < B2.date);
-- OR
SELECT O1.ship
FROM Outcomes O1
JOIN Battles B1 ON O1.battle = B1.name
JOIN Outcomes O2 ON O1.ship = O2.ship
JOIN Battles B2 ON O2.battle = B2.name
WHERE O1.result = 'damaged'
  AND B1.date < B2.date
  AND B1.name <> B2.name;
         
-- !f) Find those battles with at least three ships of the same country.
SELECT O.battle
FROM Outcomes O, Ships S, Classes C
WHERE O.ship = S.name
  AND S.class = C.class
GROUP BY C.country, O.battle
HAVING COUNT(O.ship) >= 3;
-- OR
SELECT O.battle
FROM Outcomes O
JOIN Ships S ON O.ship = S.name
JOIN Classes C ON S.class = C.class
GROUP BY C.country, O.battle
HAVING COUNT(O.ship >= 3);