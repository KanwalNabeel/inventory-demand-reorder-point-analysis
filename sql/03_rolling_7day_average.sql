-- 7-day rolling average demand per store/item (window function):
-- smooths daily noise so the underlying trend is visible.
SELECT
  store,
  item,
  date,
  sales,
  ROUND(AVG(sales) OVER (
    PARTITION BY store, item
    ORDER BY date
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
  )::numeric, 1) AS rolling_7day_avg
FROM sales_raw
ORDER BY store, item, date;
