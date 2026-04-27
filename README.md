# 🍕 Pizza Sales Analytics

> End-to-end pizza sales analysis — from raw SQL Server data to an interactive Power BI dashboard — uncovering revenue trends, peak ordering times, category performance, and product rankings.

---

## 🗂️ Table of Contents

- [Project Overview](#project-overview)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Dataset Summary](#dataset-summary)
- [KPI Metrics](#kpi-metrics)
- [SQL Analytics](#sql-analytics)
- [Power BI Dashboard](#power-bi-dashboard)
- [Business Recommendations](#business-recommendations)
- [Getting Started](#getting-started)

---

## Project Overview

This project delivers a **complete, end-to-end pizza sales analysis** using Microsoft SQL Server (T-SQL) and Power BI. It covers five analytical layers:

1. **KPI Aggregation** — 5 core business metrics computed from the `pizza_sales` table
2. **Trend Analysis** — Daily, monthly, and hourly order patterns using `DATENAME` / `DATEPART`
3. **Category & Size Breakdown** — Revenue percentage by pizza category and size
4. **Product Rankings** — Top 5 and Bottom 5 pizzas by Revenue, Quantity, and Total Orders
5. **Power BI Dashboard** — Two-page interactive dashboard (Home + Best/Worst Sellers)

---

## Tech Stack

| Layer | Tool |
|---|---|
| Database | Microsoft SQL Server |
| Query Language | T-SQL (SQL Server dialect) |
| Visualisation | Power BI Desktop |

---

## Project Structure

```
pizza-sales-analytics/
│
├── Pizza_Sql_Quries.sql           # All KPI, trend, category & ranking queries
├── Pizza_Analysis_Dashboard.pbix  # Power BI dashboard file
├── dashboard_home.png             # Screenshot — Home page
├── dashboard_sellers.png          # Screenshot — Best/Worst Sellers page
├── pizza_sales.csv                # Raw dataset (not tracked in git)
└── README.md
```

---

## Dataset Summary

The dataset lives in the `Pizza_database` SQL Server database, in the table **`pizza_sales`**. Each row is a single order line item.

| Column | Type | Description |
|---|---|---|
| `order_id` | INT | Unique identifier for each customer order |
| `order_date` | DATE | Date the order was placed |
| `order_time` | TIME | Time the order was placed |
| `pizza_name` | VARCHAR | Full descriptive name of the pizza |
| `pizza_category` | VARCHAR | Category: Classic, Supreme, Veggie, Chicken |
| `pizza_size` | CHAR | Size: S, M, L, XL, XXL |
| `quantity` | INT | Units of that pizza in the order |
| `unit_price` | DECIMAL | Price per individual pizza |
| `total_price` | DECIMAL | `quantity × unit_price` for the line item |

---

## KPI Metrics

Five headline KPIs computed directly from `pizza_sales`:

| KPI | Value | SQL |
|---|---|---|
| Total Revenue | **$817,860.05** | `SUM(total_price)` |
| Total Orders | **21,350** | `COUNT(DISTINCT order_id)` |
| Total Pizzas Sold | **49,574** | `SUM(quantity)` |
| Avg Order Value | **$38.31** | `SUM(total_price) / COUNT(DISTINCT order_id)` |
| Avg Pizzas Per Order | **2.32** | `SUM(quantity) / COUNT(DISTINCT order_id)` |

---

## SQL Analytics

All queries are in [`Pizza_Sql_Quries.sql`](./Pizza_Sql_Quries.sql).

### Trend Analysis

| Query | Function Used | Key Finding |
|---|---|---|
| Daily Trend | `DATENAME(DW, order_date)` | Friday is the busiest day (3,538 orders) |
| Monthly Trend | `DATENAME(MONTH, order_date)` | July peaks at 1,935 orders |
| Hourly Trend | `DATEPART(HOUR, order_time)` | Lunch (12–1 PM) and Dinner (5–7 PM) rush |

**Daily Trend Query**
```sql
SELECT DATENAME(DW, order_date)  AS Order_Day,
       COUNT(DISTINCT order_id)  AS Total_Orders
FROM   pizza_sales
GROUP  BY DATENAME(DW, order_date)
```

**Hourly Trend Query**
```sql
SELECT DATEPART(HOUR, order_time) AS Order_Hours,
       COUNT(DISTINCT order_id)   AS Total_Orders
FROM   pizza_sales
GROUP  BY DATEPART(HOUR, order_time)
ORDER  BY DATEPART(HOUR, order_time)
```

---

### Category & Size Breakdown

**% of Sales by Pizza Category**
```sql
SELECT pizza_category,
       CAST(SUM(total_price) AS DECIMAL(10,2)) AS Total_Revenue,
       CAST(SUM(total_price * 100) /
            (SELECT SUM(total_price) FROM pizza_sales)
            AS DECIMAL(10,2)) AS PCT
FROM   pizza_sales
GROUP  BY pizza_category
```

| Category | Revenue ($) | Share |
|---|---|---|
| Classic | 220,053.10 | 26.91% |
| Supreme | 208,197.00 | 25.46% |
| Chicken | 195,919.50 | 23.96% |
| Veggie  | 193,690.45 | 23.68% |

**% of Sales by Pizza Size**

| Size | Revenue ($) | Share |
|---|---|---|
| Large  | 375,318.70 | 45.89% |
| Medium | 249,382.25 | 30.49% |
| Small  | 178,076.50 | 21.77% |
| XL     | 14,076.00  | 1.72%  |
| XXL    | 1,006.60   | 0.12%  |

---

### Product Performance Rankings

Six queries rank individual pizzas across three dimensions using `TOP 5` + `ORDER BY`:

```sql
-- Top 5 by Revenue
SELECT TOP 5 pizza_name, SUM(total_price) AS Total_Revenue
FROM   pizza_sales
GROUP  BY pizza_name
ORDER  BY Total_Revenue DESC

-- Bottom 5 by Revenue
SELECT TOP 5 pizza_name, SUM(total_price) AS Total_Revenue
FROM   pizza_sales
GROUP  BY pizza_name
ORDER  BY Total_Revenue        -- ASC = lowest first
```

**Best Sellers**

| Metric | #1 Pizza | Value |
|---|---|---|
| Revenue | The Thai Chicken Pizza | $43,434.25 |
| Quantity | The Classic Deluxe Pizza | 2,453 units |
| Total Orders | The Classic Deluxe Pizza | 2,329 orders |

**Worst Sellers**

| Metric | Last Pizza | Value |
|---|---|---|
| Revenue | The Brie Carre Pizza | $11,588.50 |
| Quantity | The Brie Carre Pizza | 490 units |
| Total Orders | The Brie Carre Pizza | 480 orders |

> **Note:** Brie Carre Pizza ranks last across all three metrics — a strong candidate for menu retirement or recipe reinvention.

---

## Power BI Dashboard

The dashboard file [`Pizza_Analysis_Dashboard.pbix`](./Pizza_Analysis_Dashboard.pbix) connects directly to the SQL Server `pizza_sales` table.

### Page 1 — Home

![Pizza Sales Dashboard - Home](./dashboard_home.png)

Displays all five KPI cards, Daily Trend bar chart, Monthly Trend line chart, % of sales by category and size donut charts, and total pizzas sold by category.

### Page 2 — Best / Worst Sellers

![Pizza Sales Dashboard - Best / Worst Sellers](./dashboard_sellers.png)

Six bar charts showing Top 5 and Bottom 5 pizzas by Revenue, Quantity, and Total Orders, with a sidebar summary of key performers and laggards.

### Dashboard Features

- **Pizza Category slicer** — filter all visuals by Classic, Supreme, Veggie, or Chicken
- **Date range slicer** — filter by any custom date window within Jan–Dec 2015
- **Toggle navigation** — switch between Home and Best/Worst Sellers pages via sidebar
- **Conditional bar colours** — green for top performers, red for bottom performers
- **DAX measures** — percentage share calculations, running totals, and order counts
- **Tooltips** — hover over any chart element for exact values

### Data Connection Setup

```
Server:   localhost  (or your SQL Server instance name)
Database: Pizza_database
Table:    pizza_sales
Mode:     Import
Refresh:  Manual / Scheduled daily
```

---

## Business Recommendations

| # | Recommendation |
|---|---|
| 1 | **Friday & weekend promotions** — Friday drives 3,538 orders (highest day); launch combo deals to grow basket size |
| 2 | **Staff up at Lunch (12–1 PM) and Dinner (5–7 PM)** — two daily rush windows dominate hourly order volume |
| 3 | **Push Large size upgrades** — Large accounts for 45.89% of revenue; "Upsize for $1" prompts can grow AOV |
| 4 | **Invest in Chicken category marketing** — Thai Chicken & BBQ Chicken are the top two revenue pizzas |
| 5 | **Promote or retire Brie Carre Pizza** — last in Revenue, Quantity, and Orders across the full year |
| 6 | **Stock up ahead of July** — peak order month; Q1 (Jan–Mar) is also consistently strong |
| 7 | **Bundle deals to grow AOV** — current AOV is $38.31; Meal Deal bundles anchored at $45–$50 can nudge spend |
| 8 | **Monthly menu performance review** — automate dashboard refresh; flag any pizza below 50% of category average |

---

## Getting Started

### Prerequisites

- Microsoft SQL Server (2016 or later)
- SQL Server Management Studio (SSMS) or Azure Data Studio
- Power BI Desktop

### Setup

**1. Clone the repository**
```bash
git clone https://github.com/your-username/pizza-sales-analytics.git
cd pizza-sales-analytics
```

**2. Create the database and load data**
```sql
CREATE DATABASE Pizza_database;
USE Pizza_database;

-- Import pizza_sales.csv via SSMS Import Wizard or BULK INSERT:
BULK INSERT pizza_sales
FROM 'C:\path\to\pizza_sales.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
```

**3. Run the SQL queries**

Open `Pizza_Sql_Quries.sql` in SSMS or Azure Data Studio and execute against `Pizza_database`.

**4. Open the Power BI dashboard**

Open `Pizza_Analysis_Dashboard.pbix` in Power BI Desktop. Update the SQL Server connection under **Home → Transform Data → Data Source Settings** if your server name differs from `localhost`.

---

> Built with T-SQL (SQL Server) and Power BI Desktop
