--a
SELECT * FROM dealer CROSS JOIN client;

--b
SELECT c.name as client,c.city,c.priority,d.name as dealer ,s.id,s.date,s.amount
FROM client c RIGHT OUTER JOIN dealer d ON c.dealer_id=d.id
     RIGHT OUTER JOIN sell s ON s.client_id = c.id;

--c
SELECT dealer.id, dealer.name,client.id,client.name,client.city
FROM dealer CROSS JOIN client
WHERE dealer.location=client.city;

--d
SELECT sell.id,amount,client.name,client.city
FROM sell,client
WHERE sell.client_id=client.id AND sell.amount BETWEEN 100 AND 500;

--e
SELECT d.id, d.name, count(c.id) as "Clients number"
FROM dealer d LEFT OUTER JOIN client c
ON d.id = c.dealer_id
GROUP BY d.id, d.name;

--f
SELECT client.name,client.city,dealer.name, dealer.charge as "commission"
FROM dealer INNER JOIN client
ON dealer.id = client.dealer_id;

--g
SELECT client.name,client.city,dealer.name, dealer.charge as "commission"
FROM dealer,client
WHERE dealer.id = client.dealer_id AND dealer.charge*100>12;

--h
SELECT c.name, c.city,s.id,s.date,s.amount,d.name,d.charge as commission
FROM client c LEFT OUTER JOIN sell s ON c.id = s.client_id
    LEFT OUTER JOIN dealer d on d.id = s.dealer_id;

--i
SELECT c.name, c.priority,d.name,s.id,s.amount
FROM client c RIGHT OUTER JOIN dealer d ON d.id=c.dealer_id
    LEFT OUTER JOIN sell s ON s.client_id= c.id
WHERE
    s.amount>=2000 AND
    c.priority IS NOT NULL;