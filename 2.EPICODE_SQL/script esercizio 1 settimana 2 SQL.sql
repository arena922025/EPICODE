# Esploro Database dimproducts
SELECT*FROM dimproduct;
# INTERROGO TABELLA PRODOTTI E CAMPI: ProductKey,ProductAlternateKey,EnglishProductName,Color,StandardCost,FinishedGoodsFlag, rinomino FinishedGoodsFlag con FGF e espongo solo i dati uguali a 1
select ProductKey, ProductAlternateKey, EnglishProductName, Color, StandardCost, FinishedGoodsFlag as FGF 
from dimproduct
where FinishedGoodsFlag=1;
# filtro solo i profotti che iniziano con FR e BK
select ProductKey, ProductAlternateKey, EnglishProductName, Color, StandardCost, FinishedGoodsFlag from dimproduct where ProductAlternateKey like "FR%" or ProductAlternateKey like "bk%";
# filtro solo i profotti che iniziano con FR e BK
select ProductKey, ProductAlternateKey, EnglishProductName, StandardCost, ListPrice from dimproduct where ProductAlternateKey like "FR%" or ProductAlternateKey like "bk%";
# filtro solo i profotti che iniziano con FR e BK,aggiungo alias StandardCost as markup
select ProductKey, ProductAlternateKey, EnglishProductName, StandardCost, ListPrice, ListPrice - StandardCost as markup
from dimproduct where ProductAlternateKey like "FR%" or ProductAlternateKey like "bk%";
# filtro solo i profotti che iniziano con FR e BK,aggiungo alias StandardCost as markup, rinomino FinishedGoodsFlag con FGF e espongo solo i dati uguali a 1
select ProductKey, ProductAlternateKey, EnglishProductName, StandardCost, FinishedGoodsFlag as FGF, ListPrice,
 ListPrice - StandardCost as markup from dimproduct where (ListPrice >1000 and ListPrice<2000)
and (ProductAlternateKey like "FR%" or ProductAlternateKey like "bk%") and (FinishedGoodsFlag=1);
# esploro dimemployee
SELECT*FROM dimemployee;
# cerco in SalesPersonFlag solo gli agenti =1
select FirstName,LastName, DepartmentName,SalesPersonFlag from dimemployee where SalesPersonFlag=1;
#variante uguale
SELECT*FROM dimemployee where SalesPersonFlag=1;
# interrogo tabella vendite con filtro su data e i soli codici prodotto 597,598,477,241
SELECT*FROM factresellersales where (OrderDate >"2020-01-01") and (ProductKey in (597,598,477,241));
# calcolo profitto: SalesAmount - TotalProductCost
select SalesOrderNumber, OrderDate, ProductKey, OrderQuantity, UnitPrice, TotalProductCost, SalesAmount, SalesAmount - TotalProductCost 
as Markup from factresellersales where (OrderDate > '2020-01-01') AND (ProductKey in (597, 598, 477, 214));