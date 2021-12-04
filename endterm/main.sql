CREATE TABLE buyer
(
id         SERIAL PRIMARY KEY,
first_name VARCHAR(20) NOT NULL,
last_name  VARCHAR(20) NOT NULL
);

INSERT INTO buyer
VALUES (16592, 'John', 'Smith');
INSERT INTO buyer
VALUES (44815, 'Akmaral', 'Tazhiyeva');
INSERT INTO buyer
VALUES (52082, 'Olula', 'Kanatova');
INSERT INTO buyer
VALUES (77780, 'Damir', 'Erzhigitov');
INSERT INTO buyer
VALUES (97824, 'Merei', 'Inirbay');

CREATE TABLE company
(
id          SERIAL PRIMARY KEY,
name        VARCHAR(20) NOT NULL,
country     VARCHAR(20) NOT NULL,
city        VARCHAR(20) NOT NULL,
street      VARCHAR(20),
num         INTEGER
);

INSERT INTO company
VALUES (45687, 'Hundai', 'Kanada', 'Otava', 'John', 18 );

CREATE TABLE vehicle
(
id           SERIAL PRIMARY KEY,
vin          VARCHAR(20) NOT NULL,
title        VARCHAR     NOT NULL,
type         VARCHAR     NOT NULL,
brand        VARCHAR     NOT NULL,
price        NUMERIC     NOT NULL,
manufacturer VARCHAR     NOT NULL,
inventory    VARCHAR     NOT NULL
);
INSERT INTO vehicle
VALUES (79564, 'FDHUF', 'Lamba', 'sport', 'hunday', '15,000,000', 'china', 'usa');
INSERT INTO vehicle
VALUES (14587, 'KUBRS', 'Toyota', 'sedan', 'gucci', '20,000,000', 'japan', 'usa');
INSERT INTO vehicle
VALUES (79521, 'RYTKD', 'Bmw', 'sport', 'audi', '10,000,000', 'canada', 'usa');
INSERT INTO vehicle
VALUES (36144, 'HFTRE', 'Kia', 'sedan', 'mazda', '50,000,000', 'kazakhstan', 'usa');
INSERT INTO vehicle
VALUES (12547, 'REWDS', 'Crossover', 'wagon', 'van', '7,000,000', 'brazil', 'usa');

CREATE TABLE options
(
vehicle_id  INTEGER PRIMARY KEY REFERENCES vehicle (id),
color       VARCHAR NOT NULL,
engine      VARCHAR NOT NULL,
transmissions   VARCHAR NOT NULL
);

INSERT INTO options
VALUES (79564, 'Red', 'mechanic', 'manual');
INSERT INTO options
VALUES (14587, 'Black', 'electrical', 'semi-automatic');
INSERT INTO options
VALUES (36144, 'White', 'mechanic', 'continuously');
INSERT INTO options
VALUES (12547, 'Blue', 'electrical', 'manual');
INSERT INTO options
VALUES (79521, 'Green', 'mechanic', 'continuously');

CREATE TABLE dealers
(
id          SERIAL PRIMARY KEY,
name        VARCHAR(20) NOT NULL,
company_id  SERIAL REFERENCES company(id),
buyer_id    SERIAL REFERENCES buyer(id)
);

INSERT INTO dealers
VALUES (45987, 'Lola', 45687, 44815);
INSERT INTO dealers
VALUES (69874, 'Bunny', 45687, 97824);
INSERT INTO dealers
VALUES (12647, 'Bugz', 45687, 77780);
INSERT INTO dealers
VALUES (58745, 'Liam', 45687, 16592);
INSERT INTO dealers
VALUES (32547, 'Phiona', 45687, 52082);

CREATE TABLE supplier
(
id          SERIAL PRIMARY KEY,
name        VARCHAR(20) NOT NULL,
address     VARCHAR NOT NULL
);

INSERT INTO supplier
VALUES (94465, 'Michael', 'Canada');
INSERT INTO supplier
VALUES (13574, 'Jinx', 'China');
INSERT INTO supplier
VALUES (47165, 'Kusaka', 'Usa');
INSERT INTO supplier
VALUES (32547, 'Anna', 'Russian');
INSERT INTO supplier
VALUES (54778, 'Sati', 'Japan');

CREATE TABLE purchase
(
id          SERIAL PRIMARY KEY,
buyer_id    SERIAL REFERENCES buyer (id),
vehicle_id  SERIAL REFERENCES vehicle (id),
dealer_id   SERIAL REFERENCES dealers (id),
supplier_id SERIAL REFERENCES supplier (id),
total_price NUMERIC NOT NULL,
credit_card NUMERIC NOT NULL,
purchase_date VARCHAR NOT NULL,
amount      VARCHAR NOT NULL
);

INSERT INTO purchase
VALUES (74521, 16592, 79564, 45987, 94465, 10000000, 44005998, '2011-04-18', '10kk');
INSERT INTO purchase
VALUES (14257, 44815, 14587, 69874, 13574, 25000000, 44006558, '2018-07-28', '25kk');
INSERT INTO purchase
VALUES (74532, 52082, 79521, 12647, 47165, 5000000, 44003214, '2020-04-08', '5kk');
INSERT INTO purchase
VALUES (32654, 77780, 36144, 58745, 32547, 30000000, 44009874, '2010-11-23', '50kk');
INSERT INTO purchase
VALUES (98541, 97824, 12547, 32547, 54778, 38000000, 44001147, '2013-08-12', '38kk');