/*CH4Q1 1. Providethelistofmarketsinwhichcustomer"AtliqExclusive"operatesits business in the APAC region.*/

SELECT Market FROM dim_customer
WHERE region = 'APAC' and customer = 'Atliq Exclusive';

/*CH4Q2 2. What is the percentage of unique product increase in 2021 vs. 2020? The final output contains these fields,
unique_products_2020 unique_products_2021 percentage_chg*/

with p2020 as
(select count( distinct product_code) as unique_products_2020, fiscal_year FROM gdb0041.fact_forecast_monthly where fiscal_year =2020),
p2021 as 
(select count(distinct product_code) as unique_products_2021, fiscal_year FROM gdb0041.fact_forecast_monthly where fiscal_year =2021)
Select p2020.unique_products_2020,p2021.unique_products_2021,round((p2021.unique_products_2021 - p2020.unique_products_2020)*100/p2020.unique_products_2020,2) as percentage_change
from  p2020,p2021;

/*CH4Q3 3. Provide a report with all the unique product counts for each segment and sort them in descending order of product counts. The final output contains 2 fields,
segment product_count*/

Select segment,count(distinct product_code) as Product_Count from dim_product
group by segment
order by Product_Count desc;

/*CH4Q4 4. Follow-up: Which segment had the most increase in unique products in 2021 vs 2020? The final output contains these fields,
segment product_count_2020 product_count_2021 difference*/

With P2020 as
(Select P.segment,M.fiscal_year,Count(distinct P.product_code) as Product_Count_2020 from
dim_product P
Join
fact_sales_monthly M
ON P.product_code = M.product_code
Where fiscal_year =2020
Group By segment, M.fiscal_year),
P2021 as
(Select P.segment,M.fiscal_year,Count(Distinct P.product_code) As Product_Count_2021 From
dim_product P
Join
fact_sales_monthly M
ON P.product_code = M.product_code
Where fiscal_year =2021
Group By segment, M.fiscal_year)
Select P2020.segment,
P2020.Product_Count_2020,P2021.Product_Count_2021,
P2021.Product_Count_2021-P2020.Product_Count_2020 as Difference From
P2020
Join P2021
On P2020.segment =P2021.segment
Order By Difference Desc;

/*CHQ5 5. Get the products that have the highest and lowest manufacturing costs. The final output should contain these fields,
product_code product manufacturing_cost*/

Select P.product_code,P.product,fmc.cost_year,fmc.manufacturing_cost from fact_manufacturing_cost fmc
Join dim_product P
On fmc.product_code = P.product_code
where fmc.manufacturing_cost
In
(Select  Max(manufacturing_cost) from fact_manufacturing_cost
Union
Select Min(manufacturing_cost) from fact_manufacturing_cost)
Order By fmc.manufacturing_cost desc;

/*ch4q6 6. Generate a report which contains the top 5 customers who received an average high pre_invoice_discount_pct for the fiscal year 2021 and in the Indian market. The final output contains these fields,
customer_code
customer average_discount_percentage
 */

Select C.customer,C.customer_code,Round(avg(PD.pre_invoice_discount_pct),4) as Avg_discount_Pct from dim_customer C
Join fact_pre_invoice_deductions PD
On C.customer_code = PD.customer_code
Where C.market = 'India' and PD.fiscal_year =2021
Group By C.customer,C.customer_code
Order By Avg_discount_Pct desc Limit 5;

/*ch4q7 7. Get the complete report of the Gross sales amount for the customer “Atliq Exclusive” for each month. This analysis helps to get an idea of low and high-performing months and take strategic decisions.
The final report contains these columns: Month
Year
Gross sales Amount */

Select Concat(MonthName(fm.date),'(',(Year(fm.date)),')') as Month_Date,fm.fiscal_year as Fiscal_Year,
concat(Round(Sum(fg.gross_price*fm.sold_quantity)/1000000,2),'M') as Gross_Sales_Amount_Mln from fact_gross_price fg
Join fact_sales_monthly fm on
fm.product_code = fg.product_code
Join dim_customer C on
fm.customer_code = C.customer_code
Where  C.customer = 'Atliq Exclusive'
Group By Month_Date,Fiscal_Year
Order By Fiscal_Year;



/*ch4q8 8. In which quarter of 2020, got the maximum total_sold_quantity? The final output contains these fields sorted by the total_sold_quantity,
Quarter total_sold_quantity*/

	Select 
	CASE
		When date between '2019-09-01' and '2019-11-01' then 'Q1'
		When date between '2019-12-01' and '2020-02-01' then 'Q2'
		When date between '2020-03-01' and '2020-05-01' then 'Q3'
		When date between '2020-06-01' and '2020-08-01' then 'Q4'
	END as Quater,
	Concat(Round((sum(sold_quantity)/1000000),4),'M')as Total_Sold_qty,Month(date) as Month_date,fiscal_year as Fiscal_year from fact_sales_monthly
	where fiscal_year = 2020
	group by Quater
	order by Total_Sold_qty desc;

    /*CH4Q9 9. Which channel helped to bring more gross sales in the fiscal year 2021 and the percentage of contribution? The final output contains these fields,
channel gross_sales_mln percentage
*/
    With Gross_Table as (
    Select 
    C.channel,
    Round(SUM(fm.sold_quantity*fg.gross_price )/1000000,2) as Gross_Sales_Amt_Mln
    from fact_sales_monthly fm
    Join fact_gross_price fg on
    fg.product_code = fm.product_code
    Join dim_customer C on
    C.customer_code = fm.customer_code
    Where fm.fiscal_year =2021 
    Group By C.channel
    Order By Gross_Sales_Amt_Mln Desc)
    Select channel,concat(Gross_Sales_Amt_Mln,'M')  As Gross_Sales_Amt_Mln,
    Concat(Round(Gross_Sales_Amt_Mln*100 /Sum(Gross_Sales_Amt_Mln) Over(),2),'%')as Percentage
    From Gross_Table;
    
    /*CH4Q10 10. Get the Top 3 products in each division that have a high total_sold_quantity in the fiscal_year 2021? The final output contains these fields,
division product_code,product,total_sold_quantity,rank_order*/
    With Temp_Table1 as
    (Select P.division,P.product_code ,P.product,Sum(fm.sold_quantity) as Total_Sold_Qty 
    from dim_product P
    Join fact_sales_monthly fm on
    P.product_code = fm.product_code
    Where fm.fiscal_year =2021
    Group By P.product_code,P.division,P.product),
    Temp_Table2 as(
    Select division,product_code,product,Total_Sold_Qty,
   dense_rank() over(Partition by division order by Total_Sold_Qty desc) as dnrk
   from Temp_Table1) 
   Select T1.division,T1.product_code,T1.product,T2.Total_Sold_Qty,T2.dnrk as Ranked_Order
   From Temp_Table1 T1 Join Temp_Table2 T2 On
   T1.product_code = T2.product_code
   Where T2.dnrk <=3;
 
 