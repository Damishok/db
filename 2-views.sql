--a
CREATE TEMP VIEW by_date AS
    SELECT date,count(DISTINCT client_id) clients,sum(amount) AS total,avg(amount)
    FROM sell
    GROUP BY date;

SELECT * from by_date;
DROP VIEW by_date;

--b
CREATE TEMP VIEW top5 AS
    SELECT *
    FROM by_date
    ORDER BY total DESC
    LIMIT 5;
SELECT * FROM top5;
DROP VIEW top5;

--c
CREATE VIEW dealers AS
    SELECT d.id,d.name,count(DISTINCT s.id),sum(s.amount),avg(s.amount)
    FROM dealer d INNER JOIN sell s ON d.id = s.dealer_id
    GROUP BY d.id, d.name;

SELECT * FROM dealers;

--d
CREATE VIEW d1 AS --Each location made on their dealers on charge
    SELECT location,SUM(charge*amount)
    FROM dealer d LEFT JOIN sell s ON d.id = s.dealer_id
    GROUP BY location;

--e
CREATE VIEW e1 AS --Each location made on their dealers
    SELECT location,count(DISTINCT s.id),SUM(amount) as sales,AVG(amount)
    FROM dealer d LEFT JOIN sell s ON d.id = s.dealer_id
    GROUP BY location;

DROP VIEW e1;
/* CREATE VIEW e2 AS --Each Dealer made in his location
    SELECT d.id,d.name,location,count(s.id),SUM(charge*amount),AVG(charge*amount)
    FROM dealer d LEFT JOIN sell s ON d.id = s.dealer_id
    GROUP BY d.id, d.name; */

--f
CREATE VIEW f1 AS --Each city made on their citizens
    SELECT city,count(s.id),SUM(amount) as expenses,AVG(amount)
    FROM client c LEFT OUTER JOIN sell s ON s.client_id=c.id
    GROUP BY city;

DROP VIEW f1;
/*CREATE VIEW f2 AS --Each city made on their citizens
    SELECT c.id,c.name,c.city,count(s.id),SUM(amount),AVG(amount)
    FROM client c LEFT OUTER JOIN sell s ON s.client_id=c.id
    GROUP BY c.id, c.name, c.city; */

--g
CREATE VIEW comp AS
SELECT location as "Продавец",city as "Потребитель",sales as "Доход", expenses as "Расход"
FROM e1 FULL OUTER JOIN f1 ON location=city
WHERE expenses>sales or sales is NULL or sales=0;

SELECT * FROM comp;
DROP VIEW comp;

/*SELECT location,SUM(amount) from dealer LEFT JOIN sell ON sell.dealer_id=dealer.id GROUP BY location
SELECT city,SUM(amount) from client LEFT JOIN sell ON sell.client_id=client.id GROUP BY city*/
