use PORTFOLIO;

alter table dbo.AdventureWorks_Returns
add foreign key (TerritoryKey) references dbo.AdventureWorks_Territories(SalesTerritoryKey);

-- view table sale 2016 and sale 2017--
create view Sale1617 AS
select * from dbo.Sale_2016 
UNION 
select * from dbo.Sale_2017 
order by OrderDate, ProductKey offset 0 rows;

-- Sum order of productkey--
create view NumberOfOrder AS
select sum(Sale.OrderQuantity) as numberOfOrder, Sale.ProductKey
from SaleReturn1617 as Sale	
group by ProductKey
order by ProductKey offset 0 rows;
--
select * from NumberOfOrder;
--
drop view NumberOfOrder;

-- Sum return of productKey
create view NumberOfReturn AS
select sum(Re.ReturnQuantity) as numberOfReturn, Re.ProductKey
from dbo.Returns as Re
group by ProductKey
order by 1 ASC offset 0 rows;
--
select * from NumberOfReturn;
--
drop view NumberOfReturn;

-- Join table Return and table SaleAndReturnOfProduct
create view SaleAndReturnOfProduct AS
select NumberOfOrder.numberOfOrder, NumberOfReturn.numberOfReturn,Products.*
from NumberOfOrder
inner join NumberOfReturn
on NumberOfOrder.ProductKey = NumberOfReturn.ProductKey
inner join Products 
on NumberOfOrder.ProductKey = Products.ProductKey
order by NumberOfOrder.numberOfOrder, NumberOfReturn.numberOfReturn,Products.ProductName offset 0 rows;
--
select * from SaleAndReturnOfProduct;
--
drop view SaleAndReturnOfProduct;

--6 Return Rate
create view ReturnRate AS
select cast(((numberOfReturn*1.0/numberOfOrder) * 100) as numeric(10,2)) as ReturnRate, ProductName, ReturnDate
from SaleAndReturnOfProduct
inner join dbo.Returns
on SaleAndReturnOfProduct.ProductKey = dbo.Returns.ProductKey
where  ReturnDate not like '%2015%'
order by ReturnRate, ReturnDate asc offset 0 rows;
--
select * from ReturnRate;





