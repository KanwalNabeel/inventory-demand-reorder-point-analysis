-- Core deliverable: turn demand history into an inventory policy.
-- reorder point = demand during supplier lead time + safety stock
-- safety stock  = z * std dev of daily demand * sqrt(lead time in days)
-- ASSUMPTIONS (not in the data): 7-day lead time, z = 1.65 (~95% service level).
WITH demand_stats AS (
  SELECT
    store,
    item,
    ROUND(AVG(sales)::numeric, 2) AS avg_daily_demand,
    ROUND(STDDEV(sales)::numeric, 2) AS demand_stddev
  FROM sales_raw
  GROUP BY store, item
)
SELECT
  store,
  item,
  avg_daily_demand,
  demand_stddev,
  ROUND(avg_daily_demand * 7, 1) AS lead_time_demand,
  ROUND(1.65 * demand_stddev * SQRT(7::numeric), 1) AS safety_stock,
  ROUND(avg_daily_demand * 7 + 1.65 * demand_stddev * SQRT(7::numeric), 1) AS reorder_point
FROM demand_stats
ORDER BY store, item;
