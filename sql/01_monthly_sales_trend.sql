-- Monthly sales per store: is demand growing, flat or seasonal?
SELECT
  store,
  DATE_TRUNC('month', date) AS month,
  SUM(sales) AS total_sales
FROM sales_raw
GROUP BY store, DATE_TRUNC('month', date)
ORDER BY store, month;
