CREATE DATABASE toysgroup;
USE toysgroup;
# Creazione Tabelle, creo 5 tabelle: category, product,region,counntry,sales:
CREATE TABLE category (categoryid INT AUTO_INCREMENT PRIMARY KEY, categoryname VARCHAR(100) NOT NULL);
CREATE TABLE product (productid INT AUTO_INCREMENT PRIMARY KEY, productname VARCHAR(100) NOT NULL, categoryid INT,FOREIGN KEY (categoryid) REFERENCES category(categoryid));      
CREATE TABLE region (regionid INT AUTO_INCREMENT PRIMARY KEY, regionname VARCHAR(100) NOT NULL);
CREATE TABLE country (countryid INT AUTO_INCREMENT PRIMARY KEY, countryname VARCHAR(100) NOT NULL,regionid INT, FOREIGN KEY (regionid) REFERENCES region(regionid));   
CREATE TABLE sales (salesid INT AUTO_INCREMENT PRIMARY KEY,productid INT,countryid INT,salesdate DATE NOT NULL,quantity INT NOT NULL,unitprice INT NOT NULL,
FOREIGN KEY (productid) REFERENCES product(productid),FOREIGN KEY (countryid) REFERENCES country(countryid));
# Inserimento dei dati, inizio da category e region perchè sono le tabelle indipendenti:
INSERT INTO category (categoryname) VALUES ('bikes'), ('clothing');
INSERT INTO region (regionname) VALUES ('westeurope'), ('southeurope');
INSERT INTO product (productname, categoryid) VALUES ('bike-100', 1), ('bike-200', 1), ('bike glove m', 2), ('bike glove l', 2);
INSERT INTO country (countryname, regionid) VALUES ('france', 1), ('germany', 1), ('italy', 2), ('greece', 2);
INSERT INTO sales (productid, countryid, salesdate, quantity, unitprice) VALUES (1, 3, '2024-06-01', 10, 299), (2, 1, '2024-05-20', 5, 349), (3, 4, '2023-12-15', 20, 19),
(4, 2, '2024-01-10', 15, 21);
# 1) Verificare che i campi definiti come PK siano univoci. In altre parole, scrivi una query per determinare l’univocità dei valori di ciascuna PK (una query per tabella implementata).
SELECT * FROM category;
SELECT productname, categoryid FROM product;
SELECT * FROM region;
SELECT countryname, regionid FROM country;
SELECT * FROM sales;
SELECT DISTINCT productid FROM sales;
SELECT * FROM sales WHERE countryid = 3;
# 2) Esporre l’elenco delle transazioni indicando nel result set il codice documento, la data, il nome del prodotto, la categoria del prodotto, il nome dello stato, il nome della regione di 
# vendita e un campo booleano valorizzato in base alla condizione che siano passati più di 180 giorni dalla data vendita o meno (>180 -> True, <= 180 -> False).
SELECT s.salesid,s.salesdate,p.productname,c.categoryname,co.countryname,r.regionname,
IF(DATEDIFF('2025-06-14', s.salesdate) > 180, 'TRUE', 'FALSE') AS oltre_180_giorni
FROM sales s
JOIN product p ON s.productid = p.productid
JOIN category c ON p.categoryid = c.categoryid
JOIN country co ON s.countryid = co.countryid
JOIN region r ON co.regionid = r.regionid;
# 3)Esporre l’elenco dei prodotti che hanno venduto, in totale, una quantità maggiore della media delle vendite realizzate nell’ultimo anno censito. (ogni valore della condizione deve risultare
# da una query e non deve essere inserito a mano). Nel result set devono comparire solo il codice prodotto e il totale venduto.
SELECT s.productid,SUM(s.quantity) AS totale_venduto
FROM sales s
WHERE YEAR(s.salesdate) = (SELECT MAX(YEAR(s1.salesdate)) 
FROM sales s1)
GROUP BY s.productid
HAVING SUM(s.quantity) > (SELECT AVG(totale_per_prodotto)
FROM (SELECT SUM(s2.quantity) AS totale_per_prodotto FROM sales s2 WHERE YEAR(s2.salesdate) = (SELECT MAX(YEAR(s3.salesdate)) FROM sales s3)
GROUP BY s2.productid) AS somma);
# 4) Esporre l’elenco dei soli prodotti venduti e per ognuno di questi il fatturato totale per anno. 
SELECT s.productid, p.productname, YEAR(s.salesdate) AS anno, SUM(s.quantity * s.unitprice) AS fatturato_totale
FROM sales s
JOIN product p ON s.productid = p.productid
GROUP BY s.productid, YEAR(s.salesdate);
# 5)	Esporre il fatturato totale per stato per anno. Ordina il risultato per data e per fatturato decrescente.
SELECT c.countryname, YEAR(s.salesdate) AS anno,
    SUM(s.quantity * s.unitprice) AS fatturato_totale
FROM sales s
JOIN country c ON s.countryid = c.countryid
GROUP BY c.countryname, YEAR(s.salesdate)
ORDER BY anno, fatturato_totale DESC;
 #6) Rispondere alla seguente domanda: qual è la categoria di articoli maggiormente richiesta dal mercato? - CLOTHING - TOTALE 35.
 SELECT c.categoryname,
SUM(s.quantity) AS totale_venduto
FROM sales s
JOIN product p ON s.productid = p.productid
JOIN category c ON p.categoryid = c.categoryid
GROUP BY c.categoryname
ORDER BY totale_venduto DESC LIMIT 1;
# 7) Rispondere alla seguente domanda: quali sono i prodotti invenduti? Proponi due approcci risolutivi differenti.
# Utilizzo una Left join cosi da vedere se non ci sono corrispondenze
SELECT p.productid, p.productname
FROM product p
LEFT JOIN sales s ON p.productid = s.productid
WHERE s.productid IS NULL;
# da qui vedo che non ci cono prodotti invenduti.
# provo un'altra query
 SELECT productid, productname
FROM product
WHERE productid NOT IN (SELECT DISTINCT productid FROM sales);
# ottengo dei null quindi non ci sono prodotti invenduti. Provo a vedere i 2 meno venduti:
SELECT s.productid, p.productname,
SUM(s.quantity) AS totale_venduto
FROM sales s
JOIN product p ON s.productid = p.productid
GROUP BY s.productid, p.productname
ORDER BY totale_venduto ASC
LIMIT 2;
# 8) Creare una vista sui prodotti in modo tale da esporre una “versione denormalizzata” delle informazioni utili (codice prodotto, nome prodotto, nome categoria)
CREATE VIEW vista_prodotti_denormalizzati AS
SELECT p.productid, p.productname,c.categoryname
FROM product p
JOIN category c ON p.categoryid = c.categoryid;
SELECT * FROM vista_prodotti_denormalizzati;
# 9) Creare una vista per le informazioni geografiche
CREATE VIEW vista_geografica AS
SELECT c.countryid, c.countryname,r.regionname
FROM country c
JOIN region r ON c.regionid = r.regionid;
SELECT * FROM vista_geografica;
        
# GRAZIE
  
    




     


