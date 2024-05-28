# Consumer-Goods-Ad_Hoc-Insights-SQL-Project-Challenge

Welcome to the Atliq Hardwares SQL Challenge! This challenge is designed to assess your technical and soft skills through a series of SQL queries and data analysis tasks.The goal is to demonstrate your ability to derive insights from data and present them effectively.

## Challenge Description

Atliq Hardwares, a leading computer hardware producer in India, is expanding its data analytics team. We are looking for junior data analysts who are skilled in both technical and soft skills. To help us find the right candidates, we have designed a SQL challenge that involves various ad-hoc requests.

## Tasks

1. **Markets for "Atliq Exclusive" in APAC Region**
   - Provide the list of markets in which customer "Atliq Exclusive" operates its business in the APAC region.

2. **Percentage Increase in Unique Products (2021 vs. 2020)**
   - Calculate the percentage increase in unique products from 2020 to 2021.
   - **Output Fields:** `unique_products_2020`, `unique_products_2021`, `percentage_chg`

3. **Unique Product Counts by Segment**
   - Generate a report with unique product counts for each segment, sorted in descending order of product counts.
   - **Output Fields:** `segment`, `product_count`

4. **Segment with Most Increase in Unique Products (2021 vs. 2020)**
   - Identify the segment with the most increase in unique products from 2020 to 2021.
   - **Output Fields:** `segment`, `product_count_2020`, `product_count_2021`, `difference`

5. **Products with Highest and Lowest Manufacturing Costs**
   - Get the products with the highest and lowest manufacturing costs.
   - **Output Fields:** `product_code`, `product`, `manufacturing_cost`

6. **Top 5 Customers by Average Pre-Invoice Discount Percentage (India, 2021)**
   - Generate a report of the top 5 customers who received the highest average pre-invoice discount percentage in India for 2021.
   - **Output Fields:** `customer_code`, `customer`, `average_discount_percentage`

7. **Gross Sales Amount for "Atliq Exclusive" by Month**
   - Provide a monthly gross sales report for the customer "Atliq Exclusive".
   - **Output Fields:** `Month`, `Year`, `Gross sales Amount`

8. **Quarter with Maximum Total Sold Quantity (2020)**
   - Identify the quarter in 2020 with the maximum total sold quantity.
   - **Output Fields:** `Quarter`, `total_sold_quantity`

9. **Channel with Highest Gross Sales (2021)**
   - Determine which channel generated the most gross sales in 2021 and the percentage of total sales.
   - **Output Fields:** `channel`, `gross_sales_mln`, `percentage`

10. **Top 3 Products by Division (2021)**
    - List the top 3 products in each division based on total sold quantity in 2021.
    - **Output Fields:** `division`, `product_code`, `product`, `total_sold_quantity`, `rank_order`

## Database Schema

This challenge involves querying the `atliq_hardware_db` database, which includes the following six main tables:

### `dim_customer` Table
Contains customer-related data.
- `customer_code`: Unique identification codes for every customer.
- `customer`: Names of customers.
- `platform`: The means by which products or services are sold (e.g., "Brick & Mortar", "E-Commerce").
- `channel`: Distribution methods used to sell a product (e.g., "Retailers", "Direct", "Distributors").
- `market`: Countries in which the customer is located.
- `region`: Geographic regions (e.g., "APAC", "EU", "NA", "LATAM").
- `sub_zone`: Sub-regions within the geographic regions (e.g., "India", "ROA", "ANZ", "SE", "NE", "NA", "LATAM").

### `dim_product` Table
Contains product-related data.
- `product_code`: Unique identification codes for each product.
- `division`: Categorizes products into groups (e.g., "P & A", "N & S", "PC").
- `segment`: Further categorizes products within the division.
- `category`: Classifies products into specific subcategories within the segment.
- `product`: Names of individual products.
- `variant`: Classifies products according to their features, prices, and other characteristics (e.g., "Standard", "Plus", "Premium").

### `fact_gross_price` Table
Contains gross price information for each product.
- `product_code`: Unique identification codes for each product.
- `fiscal_year`: Fiscal period in which the product sale was recorded.
- `gross_price`: Initial price of a product before any reductions or taxes.

### `fact_manufacturing_cost` Table
Contains the cost incurred in the production of each product.
- `product_code`: Unique identification codes for each product.
- `cost_year`: Fiscal year in which the product was manufactured.
- `manufacturing_cost`: Total cost incurred for the production of a product.

### `fact_pre_invoice_deductions` Table
Contains pre-invoice deductions information for each product.
- `customer_code`: Unique identification codes for every customer.
- `fiscal_year`: Fiscal period when the sale of a product occurred.
- `pre_invoice_discount_pct`: Percentage of pre-invoice deductions for each product.

### `fact_sales_monthly` Table
Contains monthly sales data for each product.
- `date`: Date when the sale of a product was made, in a monthly format.
- `product_code`: Unique identification codes for each product.
- `customer_code`: Unique identification codes for every customer.
- `sold_quantity`: Number of units of a product that were sold.
- `fiscal_year`: Fiscal period when the sale of a product occurred.

