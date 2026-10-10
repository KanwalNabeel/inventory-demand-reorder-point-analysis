-- Average sales by day of week: do some days consistently sell more?
SELECT
  TO_CHAR(date, 'Day') AS day_of_week,
  ROUND(AVG(sales)::numeric, 1) AS avg_sales
FROM sales_raw
GROUP BY TO_CHAR(date, 'Day'), EXTRACT(DOW FROM date)
ORDER BY EXTRACT(DOW FROM date);
