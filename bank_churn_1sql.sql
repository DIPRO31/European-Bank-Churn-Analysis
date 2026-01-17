create database bank_churn;
create table bank_customers (
CustomerId int primary key,
Surname	varchar(50),
CreditScore	int,
Geography varchar(20),
Gender varchar(10),
Age	int,
Tenure	int,
Balance	decimal(15,2),
NumOfProducts int,	
HasCrCard boolean,
IsActiveMember boolean,
EstimatedSalary	decimal(15,2),
Exited boolean
)

-- drop table bank_customers

select * from bank_customers;

-- total number of customers 

select count(customerid) as total_customers from bank_customers;

-- distinct customers by geography

select geography, count(distinct customerid) as total_customers 
from bank_customers 
group by geography;

-- check for nulls in key columns 

select 
  sum(case when customerid is null then 1 else 0 end) as customer_id_nulls,
  sum(case when creditscore is null then 1 else 0 end) as crscore_nulls,
  sum(case when geography is null then 1 else 0 end) as geography_nulls,
  sum(case when tenure is null then 1 else 0 end) as tenure_nulls,
  sum(case when age is null then 1 else 0 end) as age_nulls,
  sum(case when balance is null then 1 else 0 end) as balance_nulls
from bank_customers;

-- check for customerid duplicate 

select customerid, count(*) as customer_counts from bank_customers 
group by customerid 
having count(*) > 1;

-- count customers by gender and geography 

select count(customerid) as customer_count, gender
from bank_customers 
group by gender
order by customer_count desc;

select count(customerid) as customer_count,
geography
from bank_customers 
group by geography 
order by customer_count desc;

-- finding average per country

select round(avg(age),1) as avg_age, geography
from bank_customers 
group by geography 
order by avg_age desc;

-- finding age band distribution 

select 
 case 
 when age < 30 then '<30'
 when age between 30 and 45 then '30-45'
 when age between 46 and 60 then '45-60'
 else '60+'
 end as age_band,
 count(*) as customer_count
 from bank_customers 
 group by age_band 
 order by customer_count desc;

--  Average credit score

select round(avg(creditscore),2) as avg_crscore from bank_customers;

-- Average account balance

select round(avg(balance),2) as avg_balance from bank_customers;

-- Product ownership distribution

select NumofProducts, count(*) as customer_count
from bank_customers 
group by NumofProducts
order by NumofProducts;

-- finding the overall churn rate 

select 
count(*) as total_customers,
sum(case when exited = 1 then 1 else 0 end) as churned_customers ,
round(
 sum(case when exited = 1 then 1 else 0 end) * 100.0 / count(*), 2) as churned_percentage 
 from bank_customers;
 
 -- churn count vs non-churn count 
 
 select 
 sum(case when exited = 1 then 1 else 0 end) as churned_customers ,
 sum(case when exited = 0 then 1 else 0 end) as non_churned_customers from bank_customers;
 
 -- finding churn rate by: 
 -- gender
 
 select 
 gender, count(*) as total_customers, 
 sum(case when exited = 1 then 1 else 0 end) as churned_customers,
 round(
 sum(case when exited = 1 then 1 else 0 end) * 100.0 / count(*), 2
 ) as churned_rate
 from bank_customers 
 group by gender
 order by churned_rate desc;
 
 -- geography
 
 select geography, 
 count(*) as total_customers ,
 sum(case when exited = 1 then 1 else 0 end) as churn_customers,
 round(sum(case when exited = 1 then 1 else 0 end) * 100.0/ count(*), 2) as churned_rate 
 from bank_customers 
 group by geography
 order by churned_rate desc;
 
 
 -- Active vs inactive members 
  
 select isActivemember, 
 count(*) as total_customers_count,
 round(sum(case when exited = 1 then 1 else 0 end) * 100.0 / count(*), 2) as churned_rate
 from bank_customers 
 group by isActivemember
 order by churned_rate desc; 
 
 -- Product holding overview 
 -- Average number of products per customer

select avg(numofproducts) as avg_no_products 
from bank_customers;

-- Customers with:
-- 1 product
-- 2+ products

select 
case when numofproducts = 1 then '+1'
else '2+'  end as product_category,
count(*) as total_customers 
from bank_customers
group by product_category; 

-- Churn rate by number of products 
 
 select numofproducts,
 count(*) as total_customers, 
 round(sum(case when exited = 1 then 1 else 0 end) * 100.0 / count(*),2) as churned_rate 
 from bank_customers
 group by numofproducts 
 order by churned_rate desc;
 
 
 -- Geography based behaviour analysis 
 -- Finding differences between German, French and Spanish customers in terms of account behaviour 
 -- Average balance by country 
 
 select geography, round(avg(balance),2) as avg_balance_per_country 
 from bank_customers 
 group by Geography
 order by avg_balance_per_country desc;
 
 -- Credit score comparison across geography
 
 select geography, round(avg(creditscore),2) as avg_credit_score 
 from bank_customers 
 group by Geography
 order by avg_credit_score desc;
 
 -- Product holding patterns across geography
 
 select geography, round(avg(numofproducts),2) as avg_product_customer
 from bank_customers
 group by Geography
 order by avg_product_customer desc;
 
 -- Product distiribution per geography
 
 select geography, numofproducts,
 count(*) as total_csutomer_count
 from bank_customers
 group by Geography,NumOfProducts
 order by Geography,NumOfProducts desc;
 
 -- Activity rate per geography 
 
 select geography, 
 count(*) as total_customer_count,
 sum(case when isActiveMember = 1 then 1 else 0 end) as active_customers,
 round(
 sum(case when isActiveMember = 1 then 1 else 0 end) * 100.0 /count(*), 2 
 ) as actitvity_rate 
 from bank_customers
 group by geography
 order by actitvity_rate desc;
 
 -- Age & Lifecycle Analysis
-- Churn rate by age group

select 
case when age <30 then '<30'
when age between 30 and 45 then '30-45'
when age between 46 and 60 then '46-60'
else '60+'
end as age_band, 
count(*) as total_customers_count,
round(
sum(case when exited = 1 then 1 else 0 end) * 100.0/ count(*), 2 
) as churn_rate 
from bank_customers
group by age_band
order by churn_rate desc ;

-- Average balance across age bands

select 
case when age < 30 then '<30'
when age between 30 and 45 then '30-45'
when age between 46 and 60 then '46-60'
else '60+' 
end as age_band, 
round(avg(balance),2) as avg_balance
from bank_customers 
group by age_band
order by avg_balance desc;

-- Product adoption by age group

select 
case when age <30 then '<30'
when age between 30 and 45 then '30-45'
when age between 46 and 60 then '46-60'
else '60+'
end as age_band, numofproducts, count(*) as total_customers  
from bank_customers 
group by age_band, numofproducts
order by numofproducts desc; 

-- Identify high-risk lifecycle stages
-- Age-based lifecycle 

with age_churn as (
select 
case when age <30 then 'Young(30)'
when age between 30 and 45 then 'Early Career (30-45)'
when age between 46 and 60 then 'Mid Career (45-60)'
else 'Senior(60+)'
end as lifecycle_stage,
count(*) as total_customers,
sum(case when exited = 1 then 1 else 0 end) as churned_customers
from bank_customers
group by lifecycle_stage 
),
overall as (
select
sum(case when exited = 1 then 1 else 0 end) * 100 / count(*) as overall_churned_rate
from bank_customers 
)
select 
a.lifecycle_stage,
a.churned_customers,
a.total_customers,
round(a.churned_customers * 100.0 / a.total_customers, 2) as churn_rate,
case 
when (a.churned_customers * 1.0/ a.total_customers) > 
(select overall_churned_rate from overall) 
then 'High Risk'
else 'Low Risk'
end as risk_flag
from age_churn a
order by churn_rate desc;

-- Tenure based lifecycle 

with tenure_churn as (
select 
case when tenure <= 2 then 'New (0-2 yrs)'
when tenure between 3 and 5 then 'Developing (3-5 yrs)'
when tenure between 6 and 8 then 'Established (6-8 yrs)'
else 'Loyal (9+ yrs)'
end as lifecycle_stage,
count(*) as total_customers_count,
sum(case when exited = 1 then 1 else 0 end) as churned_customers
from bank_customers
group by lifecycle_stage
),
overall as (
select 
sum(case when exited =1 then 1 else 0 end) * 100.0/ count(*) as overall_churn_rate
from bank_customers 
)
select 
t.lifecycle_stage,
t.total_customers_count,
t.churned_customers ,
round(t.churned_customers * 100.0/ t.total_customers_count, 2) as churn_rate,
case when (t.churned_customers * 100.0/ t.total_customers_count) > (select overall_churn_rate from overall)
then 'High Risk'
else 'Low Risk'
end as risk_flag
from tenure_churn t
order by churn_rate desc;

-- Engagement & Activity Analysis
-- Churn rate for:
-- Active members
-- Inactive members

select IsActiveMember,
count(*) as total_customer_count,
sum(case when exited = 1 then 1 else 0 end) as churned_customers,
round(sum(case when exited = 1 then 1 else 0 end) * 100.0/ count(*), 2) as churned_rate
from bank_customers
group by IsActiveMember
order by churned_rate desc;

-- Product ownership vs activity status

select NumOfProducts, IsActiveMember,
count(*) as total_customer_count
from bank_customers 
group by NumOfProducts, IsActiveMember
order by NumOfProducts, IsActiveMember;

-- Tenure vs churn relationship

select tenure, count(*) as total_customers_count,
sum(case when exited = 1 then 1 else 0 end) as churned_customers,
round(sum(case when exited = 1 then 1 else 0 end) * 100.0 / count(*), 2) as churned_rate 
from bank_customers
group by tenure
order by tenure desc;

-- Value-Based Analysis
-- High-balance vs low-balance customer churn

select 
case when balance >= (select avg(balance) from bank_customers)
then 'High Balance'
else 'Low Balance'
end as balance_segment,
count(*) as total_customer_count,
sum(case when exited = 1 then 1 else 0 end) as churned_customers,
round(sum(case when exited = 1 then 1 else 0 end) * 100.0 / count(*), 2) as churn_rate 
from bank_customers 
group by balance_segment
order by churn_rate desc;

-- Revenue-at-risk estimation

-- revenue at risk (total)

select 
sum(balance) as total_revenue,
sum(case when exited = 1 then balance else 0 end) as revenue_at_risk,
round(sum(case when exited = 1 then balance else 0 end) * 100.0 / sum(balance), 2) as revenue_at_risk_percentage
from bank_customers;

-- Revenue at Risk by Customer Segment(by geography)

select geography,
sum(balance) as total_revenue,
sum(case when exited = 1 then balance else 0 end) as revenue_at_risk,
round(sum(case when exited = 1 then balance else 0 end) * 100/ sum(balance) , 2) as revenue_risk_percentage
from bank_customers
group by geography
order by revenue_risk_percentage desc;

-- Revenue at Risk by Tenure Stage

select 
case 
when tenure <=2 then 'New (0-2 yrs)'
when tenure between 3 and 5 then 'Developing (3-5 yrs)' 
when tenure between 6 and 8 then 'Established (6-8 yrs)'
else 'Loyal (9+ yrs)'
end as tenure_stage,
sum(balance) as total_revenue,
sum(case when exited = 1 then balance else 0 end) as revenue_at_risk,
round(sum(case when exited =1 then balance else 0 end) * 100.0 / sum(balance) , 2) as revenue_risk_percentage
from bank_customers
group by tenure_stage
order by revenue_risk_percentage desc;

-- Churn rate among top 20% balance holders

with balance_ranked as (
select *,
ntile(5) over (order by balance) as balance_bucket 
from bank_customers 
)
select 
count(*) as total_top_20_customers,
sum(case when exited = 1 then 1 else 0 end) as churned_customers,
round(sum(case when exited = 1 then 1 else 0 end) * 100.0 / count(*), 2) as churned_rate 
from balance_ranked
where balance_bucket = 5;

-- Segmentation dimensions : 

-- Age group
-- Balance tier (Low / Medium / High)
-- Product count
-- Activity status
-- Geography
-- Example segments : 
-- High-balance loyal customers

with customer_segments as (
select geography, customerId, NumOfProducts, exited, balance, IsActiveMember,
case when age < 30 then '<30'
when age between 30 and 45 then '30-45'
when age between 46 and 60 then '46-60'
else '60+'
end as age_group, 
case when balance < (select avg(balance) from bank_customers) then 'Low Balance'
when balance between (select avg(balance) from bank_customers) and 
   (select avg(balance) * 1.5 from bank_customers) then 'Medium Balance'
   else 'High Balance'
   end as balance_tier 
   from bank_customers 
)
select count(*) as high_balance_loyal_customers
from customer_segments
where balance_tier = 'High Balance'
and IsActiveMember = 1 
and exited = 0;

-- High-balance inactive churn risks

with customer_segments as(
select customerId,
case when age < 30 then '<30'
when age between 30 and 45 then '30-45'
when age between 46 and 60 then '46-60'
else '60+'
end as age_group,
case when balance < (select avg(balance) from bank_customers) then 'Low Balance'
when balance between (select avg(balance) from bank_customers) and (select avg(balance) * 1.5 from bank_customers) then 'Medium Balance'
else 'High Balance'
end as balance_tier,
NumOfProducts, Geography, IsActiveMember, exited, balance 
from bank_customers
)
select count(*) as total_customer_count,
round(
sum(case when exited = 1 then 1 else 0 end) * 100.0 / count(*) ,2
) as churned_rate
from customer_segments
where balance_tier = 'High Balance'
and isactivemember = 0;

-- Low-balance high-churn customers

with customer_segments as(
select customerId,
case when age < 30 then '<30'
when age between 30 and 45 then '30-45'
when age between 46 and 60 then '46-60'
else '60+'
end as age_group,
case when balance < (select avg(balance) from bank_customers) then 'Low Balance'
when balance between (select avg(balance) from bank_customers) and (select avg(balance) * 1.5 from bank_customers) then 'Medium Balance'
else 'High Balance'
end as balance_tier,
NumOfProducts, Geography, IsActiveMember, exited, balance 
from bank_customers
)
select count(*) as total_customer_count,
round(
sum(case when exited = 1 then 1 else 0 end) * 100.0 / count(*), 2
) as churned_rate
from customer_segments
where balance_tier = 'Low Balance';

-- Multi-product retained customers

with customer_segments as(
select customerId,
case when age < 30 then '<30'
when age between 30 and 45 then '30-45'
when age between 46 and 60 then '46-60'
else '60+'
end as age_group,
case when balance < (select avg(balance) from bank_customers) then 'Low Balance'
when balance between (select avg(balance) from bank_customers) and (select avg(balance) * 1.5 from bank_customers) then 'Medium Balance'
else 'High Balance'
end as balance_tier,
NumOfProducts, Geography, IsActiveMember, exited, balance 
from bank_customers
)
select NumOfProducts, count(*) as total_customer_count,
round(
sum(case when exited = 1 then 1 else 0 end) * 100.0 / count(*) , 2
) as churned_rate
from customer_segments
where NumOfProducts >2
group by NumOfProducts
order by NumOfProducts;

-- RFM-Style Banking Segmentation :
-- (Adapted for banking context)
-- Recency: Activity status
-- Frequency: Product usage
-- Monetary: Balance
-- Create RFM scores using SQL window functions and classify customers.

with rfm_base as (
select customerId, IsActiveMember, NumOfProducts, balance, 
ntile(4) over (order by balance) as monetary_score,
ntile(4) over (order by NumOfProducts) as frequency_score,
case when IsActiveMember = 1 then 4 else 1 end as recency_score
from bank_customers
)
select customerId, recency_score, frequency_score, monetary_score,
concat(recency_score, frequency_score, monetary_score) as rfm_score, 
case when recency_score = 4 and frequency_score >=3 and monetary_score >=3 then 'High Value Loyal Customers'
when recency_score = 1 and monetary_score >= 3 then 'High Value Customer at Risk'
when recency_score = 4 and frequency_score =1 then 'New/Cross-Sell Opportunities'
when recency_score = 1 and frequency_score = 1 and monetary_score = 1 then 'Low Value Churn at Risk'
else 'Mid-Tier Customers'
end as rfm_segment
from rfm_base;

-- Churn Risk Scoring (SQL-Driven) (Mandatory – Predictability) 
-- Approach
-- Assign weighted risk scores using:
-- Age
-- Balance
-- Credit score
-- Activity
-- Products
-- Classify customers as:
-- Low risk
-- Medium risk
-- High churn risk

with churn_risk_base as (
select customerId, age, balance, CreditScore, NumOfProducts, IsActiveMember,
case when age < 30 then 3
when age between 30 and 50 then 2
else 1
end as age_risk,
case 
when balance < (select avg(balance) from bank_customers) then 3
when balance < (select avg(balance) * 1.5 from bank_customers) then 2 
else 1 end as balance_risk,
case 
when CreditScore < 500 then 3 
when CreditScore between 500 and 650 then 2 
else 1 end as credit_risk,
case when isActiveMember = 0 then 4 else 1 end as activity_risk,
case 
when NumOfProducts = 1 then 3 
when NumOfProducts = 2 then 2 
else 1 end as product_risk
from bank_customers
),
risk_score as (
select  *,
(age_risk + balance_risk + credit_risk + activity_risk + product_risk) as total_risk_score
from churn_risk_base 
)
select 
customerID, total_risk_score,
case when total_risk_score >= 12 then 'High Churn Risk'
when total_risk_score between 8 and 11 then 'Medium Churn Risk'
else 'Low Risk'
end as churn_risk_segment
from risk_score
order by total_risk_score desc;

-- Cohort & Tenure-Based Analysis :
-- Churn rate by tenure bands

select 
case when tenure <=2 then 'New (0-2 yrs)'
when tenure between 3 and 5 then 'Developing (3-5 yrs)'
when tenure between 6 and 8 then 'Established (6-8 yrs)'
else 'Loyal (9+ yrs)'
end as tenure_bands,
count(*) as total_customer_count,
sum(case when exited = 1 then 1 else 0 end) as churned_customers,
round(
sum(case when exited = 1 then 1 else 0 end) * 100.0/ count(*), 2
) as churned_rate
from bank_customers
group by tenure_bands
order by churned_rate desc;

-- Balance growth by tenure

select case 
when tenure <=2 then 'New (0-2 yrs)'
when tenure between 3 and 5 then 'Developing (3-5 yrs)'
when tenure between 6 and 8 then 'Established (6-8 yrs)'
else 'Loyal (9+ yrs)'
end as tenure_bands,
round(avg(balance),2) as avg_balance,
sum(balance) as total_balance
from bank_customers 
group by tenure_bands
order by avg_balance desc;

-- Product adoption over time

select 
case when tenure <=2 then 'New (0-2 yrs)'
when tenure between 3 and 5 then 'Developing (3-5 yrs)'
when tenure between 6 and 8 then 'Established (6-8 yrs)'
else 'Loyal (9+ yrs)'
end as tenure_bands,
count(*) as total_customer_counts,
round(avg(NumOfProducts),2) as avg_products_per_customer,
sum(NumOfProducts) as total_products_held
from bank_customers 
group by tenure_bands
order by avg_products_per_customer desc;

-- Cross-Sell & Retention Opportunity Analysis :
-- Customers with high balance but single product

with avg_balance as (
select avg(balance) as avg_bal from bank_customers
)
select count(*) as high_balance_single_product_customers
from bank_customers, avg_balance
where balance >= avg_bal * 1.5
and NumOfProducts = 1 
and exited = 0;

-- Inactive customers with long tenure

select count(*) as inactive_customers_long_tenure
from bank_customers
where IsActiveMember = 0
and tenure >= 6
and exited = 0;

-- Countries with low product penetration

select geography,
round(avg(NumOfProducts),2) as avg_products_per_customer,
count(*) as total_customer_count 
from bank_customers 
group by geography
order by avg_products_per_customer asc;