select top 2 * from [dbo].[DIM_DATE]
select top 2 * from [dbo].[FACT_TRANSACTIONS]
select top 2 * from [dbo].[DIM_CUSTOMER]
select top 2 * from [dbo].[DIM_MANUFACTURER]
SELECT TOP 2* from [dbo].[DIM_MODEL]



select top 2 * from [dbo].[DIM_LOCATION]

---q1begin----

select State , CUSTOMER_NAME from [dbo].[DIM_LOCATION] as B left join [dbo].[FACT_TRANSACTIONS] as A ON A.IDLocation=B.IDLocation inner join [dbo].[DIM_CUSTOMER] as C
on C.IDCustomer = A.IDcustomer
WHERE date >= '2005-01-01'

------Q1END--------

---------Q2BEGIN-----------
select top 1 country ,state, COUNT( state) as tot_sales  , manufacturer_name from [dbo].[DIM_LOCATION] as A left join [dbo].[FACT_TRANSACTIONS] AS B on A.IDLOCATION = B. IDLOCATION 
INNER JOIN [dbo].[DIM_MODEL] AS C ON B.IDMODEL= C.IDMODEL INNER JOIN  [dbo].[DIM_MANUFACTURER] AS D ON C.IDManufacturer= D.IDManufacturer
GROUP BY COUNTRY, Manufacturer_Name,state
HAVING COUNTRY = 'US'and Manufacturer_Name='samsung'
--------Q2END--------------

-------Q3start------------

select zipcode,state,model_name ,count(totalprice) as [no of transactions]
from [dbo].[FACT_TRANSACTIONS]  inner join [dbo].[DIM_LOCATION]  on [dbo].[FACT_TRANSACTIONS].IDLocation=[dbo].[DIM_LOCATION].idlocation
left join [dbo].[DIM_MODEL] on [dbo].[FACT_TRANSACTIONS].idmodel=[dbo].[DIM_MODEL].IDModel
group by zipcode,state,model_name;


--------Q4start------

select top 1 manufacturer_name,model_name , unit_price from [dbo].[DIM_MODEL] as A left join [dbo].[DIM_MANUFACTURER] as B 
ON A.IDManufacturer = B.IDManufacturer

order by unit_price asc;


-------Q4END----------

------Q5START-------
select idmanufacturer,[dbo].[FACT_TRANSACTIONS].IDModel,AVG(totalprice) as [average price]
from [dbo].[FACT_TRANSACTIONS] inner join [dbo].[DIM_MODEL] on [dbo].[FACT_TRANSACTIONS].IDModel=[dbo].[DIM_MODEL].IDModel
where IDManufacturer IN(

SELECT top 5  [dbo].[DIM_MODEL].IDManufacturer , SUM(Quantity) from [dbo].[DIM_MODEL]   inner join [dbo].[FACT_TRANSACTIONS]  ON [dbo].[DIM_MODEL].IDModel=[dbo].[FACT_TRANSACTIONS].IDModel
left join [dbo].[DIM_MANUFACTURER] on [dbo].[DIM_MODEL].IDManufacturer=[dbo].[DIM_MANUFACTURER].IDManufacturer
GROUP BY [dbo].[DIM_MODEL].IDManufacturer
ORDER BY SUM(Quantity) desc)
GROUP BY idmanufacturer,[dbo].[FACT_TRANSACTIONS].IDModel
ORDER BY [AVERAGE PRICE];
-------Q5END------------


SELECT * FROM [dbo].[FACT_TRANSACTIONS]


-------Q6start-----------


SELECT CUSTOMER_NAME,DATE,AVG(TOTALPRICE) FROM [dbo].[DIM_CUSTOMER] AS A LEFT JOIN  [dbo].[FACT_TRANSACTIONS] AS B
ON A.IDCustomer = B.IDCustomer
WHERE DATE>='2009-01-01' AND DATE<='2009-12-31' 
GROUP BY CUSTOMER_NAME, DATE
HAVING AVG(TOTALPRICE)>500;

--------Q6END--------------

----------Q7BEGIN------------
Select Top 5 idmodel, Count(Quantity) 
From Fact_Transactions
Where Year(date) IN (2009,2009,2010)
Group by IDModel
Order by Count(Quantity) DESC;

-----------Q7END----------------

---------------Q8START-----------
select * from
(SELECT TOP 1 IDMANUFACTURER  FROM(
SELECT TOP 2 IDMANUFACTURER , SUM(TOTALPRICE*QUANTITY) AS SALES , DATE FROM [dbo].[DIM_MODEL] AS A LEFT JOIN [dbo].[FACT_TRANSACTIONS]  AS B ON A.IDMODEL=B.IDMODEL
WHERE YEAR(DATE) = 2009
GROUP BY IDMANUFACTURER,DATE
ORDER BY SALES DESC) AS T1
WHERE YEAR(DATE) =2009 
ORDER BY SALES ASC) as t
UNION
select * from
(SELECT TOP 1 IDMANUFACTURER  FROM(
SELECT TOP 2 IDMANUFACTURER , SUM(TOTALPRICE*QUANTITY) AS SALES , DATE FROM [dbo].[DIM_MODEL] AS A LEFT JOIN [dbo].[FACT_TRANSACTIONS]  AS B ON A.IDMODEL=B.IDMODEL
WHERE YEAR(DATE) = 2010
GROUP BY IDMANUFACTURER,DATE
ORDER BY SALES DESC) AS T1
WHERE YEAR(DATE) =2010
ORDER BY SALES ASC)as t;

------------q8end-------------

----------Q9 START-----------------

SELECT MODEL_NAME , DATE FROM [dbo].[DIM_MODEL] AS A LEFT JOIN  [dbo].[FACT_TRANSACTIONS]  AS B 
ON A.IDMODEL=B.IDMODEL
WHERE YEAR(DATE) = 2009 AND YEAR(DATE) NOT IN (2010);


------------Q9END------------------

---------------------Q10 START-------------------


SELECT TOP 100
Customer_Name, Year, AverageSpend, AverageQuantity, Difference/PreviousSpend * 100 AS [% of Change in Spend]
FROM(SELECT 
     Customer_Name, YEAR(Date) AS [Year], AVG(TotalPrice) AS [AverageSpend], AVG(Quantity) AS [AverageQuantity],
	 AVG(TotalPrice) - LAG(AVG(TotalPrice)) OVER (PARTITION BY Customer_Name ORDER BY YEAR(Date)) AS [Difference],
	 LAG(AVG(TotalPrice)) OVER (PARTITION BY Customer_Name ORDER BY YEAR(Date)) AS [PreviousSpend]
     FROM DIM_CUSTOMER INNER JOIN FACT_TRANSACTIONS ON DIM_CUSTOMER.IDCustomer = FACT_TRANSACTIONS.IDCustomer
	 GROUP BY Customer_Name, YEAR(Date)) AS [T1]
ORDER BY AverageSpend DESC, AverageQuantity DESC;

-------------------Q10END-------------------























SELECT * FROM [dbo].[FACT_TRANSACTIONS]
























 












 


















