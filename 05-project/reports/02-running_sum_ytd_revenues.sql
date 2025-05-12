-- 02. YTD calculation and monthly growth analysis

/* Monthly Revenues
	- EXTRACT of YEAR and MONTH
	- Total monthly quantities
	- JOIN orders and order_details
	- GROUP BY YEAR and MONTH
*/
WITH monthly_revenues AS (
	SELECT
		EXTRACT(YEAR FROM o.order_date) AS year,
		EXTRACT(MONTH FROM o.order_date) AS month,
		SUM((od.unit_price * od.quantity) * (1 - od.discount)) AS month_revenue
	FROM orders o
	JOIN order_details od
		ON o.order_id =  od.order_id
	GROUP BY 1, 2
	ORDER BY 1, 2
),
-- YTD Monthly Revenues

ytd_monthly_revenues AS (
	SELECT
		month,
		year,
		month_revenue,
		SUM(month_revenue) OVER (PARTITION BY year ORDER BY month) AS ytd_revenue
	FROM monthly_revenues
)
/*
Use LAG to get the monthly progression and the difference between each month. 
Get:
- Difference from previous month
- Percentage difference from previous month.
- YoY difference, in absolute and percentage values.
*/
SELECT
	year,
	month,
	month_revenue,
	LAG(month_revenue) OVER(ORDER BY year, month) AS month_revenue_lm,
	month_revenue - LAG(month_revenue) OVER(ORDER BY year,month) AS month_diff,
	(month_revenue - LAG(month_revenue) OVER(ORDER BY year, month)) / LAG(month_revenue) OVER(ORDER BY year,month) AS month_pct_diff,
	LAG(month_revenue, 12) OVER(ORDER BY year, month) AS month_revenue_ly,
	(month_revenue - LAG(month_revenue, 12) OVER(ORDER BY year,month)) AS month_yoy_diff,
	(month_revenue - LAG(month_revenue, 12) OVER(ORDER BY year,month))/ LAG(month_revenue, 12) OVER (ORDER BY year, month) AS month_yoy_pct_diff,
	ytd_revenue
FROM ytd_monthly_revenues
ORDER BY 1, 2;
