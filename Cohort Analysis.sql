Understanding: The final goal of the query is to do cohort analysis and find out which were retained and which of them will be lost.
So, i assumed that the we looking for customers who visited in jan and checked for the pattern over the full year.
 
--1)
-- To find out the about the customers and the months they have visited. 
-- #Assumption looking to retain customers who visited in Jan
-- check these customers behaviour over the rest of the year

select year(transc_date),
		month(transc_date),
		count(distinct cust_id) as 'number of cust'
		
from dataset

where year(transc_date) = 2017
and cust_id in (select distinct cust_id
From dataset
Where month(transc_date)=1
And year(transc_date)= 2017)
group by 1, 2

--above query gives data for number of cust visited in respective month of particular year


-- finding out the customers when they visited based on the months
select cust_id,
		datadiff(month, ‘2000–01–01’, transc_date) as 'visited_month'
		
from dataset
group by 1, 2
order by 1, 2


--2)Finding out the customers that have been retained and the inner query shows which customers were retained and which customers were lost.
-- time between each visit and the difference between there visit
-- and its respective percentage
select visited_month,
count(case when result = 'retained' then 1 else 0 end)*1.0/count(cust_id)*100 as retention_pct
from(
select cust_id,
visited_month,
case 
when diff = 1 then 'retained'
when diff > then 'lagger'
when diff is null then 'lost'
end
as result
from (
select cust_id, visited_month, leading_by, leading_by - visited_month as diff
(
select cust_id,
visited_month, lead(visited_month, 1) over (partition by cust_id order by cust_id, visited_month) as leading_by
from (
select cust_id,
		datadiff(month, ‘2000–01–01’, transc_date) as 'visited_month'
		
from dataset
group by 1, 2
order by 1, 2
)
)
)
)