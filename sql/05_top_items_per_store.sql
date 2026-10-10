-- Top 10 best-selling items per store (RANK): which SKUs matter most
-- for inventory optimization.
WITH item_totals AS (
  SELECT
    store,
    item,
    SUM(sales) AS total_sales,
    RANK() OVER (PARTITION BY store ORDER BY SUM(sales) DESC) AS sales_rank
  FROM sales_raw
  GROUP BY store, item
)
SELECT * FROM item_totals
WHERE sales_rank <= 10
ORDER BY store, sales_rank;
