-- Year-over-year sales growth per store/item using LAG().
-- NULLIF avoids divide-by-zero if a prior year had no sales.
WITH yearly_sales AS (
  SELECT
    store,
    item,
    EXTRACT(YEAR FROM date) AS year,
    SUM(sales) AS total_sales
  FROM sales_raw
  GROUP BY store, item, EXTRACT(YEAR FROM date)
)
SELECT
  store,
  item,
  year,
  total_sales,
  LAG(total_sales) OVER (PARTITION BY store, item ORDER BY year) AS prev_year_sales,
  ROUND(
    (total_sales - LAG(total_sales) OVER (PARTITION BY store, item ORDER BY year))::numeric
    / NULLIF(LAG(total_sales) OVER (PARTITION BY store, item ORDER BY year), 0) * 100,
    1
  ) AS yoy_growth_pct
FROM yearly_sales
ORDER BY store, item, year;
