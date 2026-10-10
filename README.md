# Inventory Demand Analysis & Reorder Point Optimization

**Business question:** How much stock should each store hold per item so it rarely runs out, without over-ordering?

## Dashboard

[Live interactive dashboard on Tableau Public](https://public.tableau.com/app/profile/kanwal.nabeel/viz/InventoryDemandReorderPointAnalysis/Dashboard)

## Data

[Store Item Demand Forecasting Challenge](https://www.kaggle.com/c/demand-forecasting-kernels-only/data) (Kaggle): 913,000 daily sales records, 10 stores x 50 items, 2013-2017. The raw file is not included in this repo.

## Approach

All analysis is in PostgreSQL (see `/sql`, run in order):

| File | Question it answers |
|---|---|
| `00_setup_date_cast.sql` | Converts the imported text `date` column to a real date type |
| `01_monthly_sales_trend.sql` | Is demand growing, flat or seasonal? |
| `02_day_of_week_seasonality.sql` | Do some weekdays consistently sell more? |
| `03_rolling_7day_average.sql` | What is the underlying trend once daily noise is smoothed out? (window function) |
| `04_year_over_year_growth.sql` | Which items are growing or declining year over year? (`LAG`) |
| `05_top_items_per_store.sql` | Which items matter most per store? (`RANK`) |
| `06_reorder_point_safety_stock.sql` | What reorder point and safety stock should each store-item use? |

## Key results

**Demand is strongly seasonal.** In store 1, monthly sales rise from about 41K in January to a peak of about 71K in June, then fall back to about 46K in December.

**Weekends sell more.** Saturday and Sunday average about 60 units per day versus about 49 on Monday to Friday, roughly 23% more.

**Reorder points differ a lot by item.** Using a 7-day lead time and a 95% service level, reorder points across all 500 store-item combinations range from about 110 to 918 units, and the item matters more than the store. Two examples from store 1:

| Store 1 item | Avg daily demand | Std dev | Safety stock | Reorder point |
|---|---|---|---|---|
| Item 1 | 19.97 | 6.74 | 29.4 | ~169 units |
| Item 8 | 69.47 | 18.75 | 81.9 | ~568 units |

## Method and assumptions

- **Reorder point** = demand during supplier lead time + safety stock.
- **Safety stock** = 1.65 x standard deviation of daily demand x sqrt(lead time in days). 1.65 is the z-score for a ~95% service level.
- The 7-day lead time and 95% service level are **assumptions**, not values from the data. Change them in `06_reorder_point_safety_stock.sql` to test other policies.
- Assumes daily demand is roughly normally distributed and independent from day to day.

## Limitations and next steps

- The reorder points use one average across all five years and all months. Because demand is seasonal, they will be too low in peak months and too high in the off-season. A better version would compute reorder points per season, or from a forecast.
- Next step: add a time-series forecast in Python and compare forecast-based reorder points to these static ones.
