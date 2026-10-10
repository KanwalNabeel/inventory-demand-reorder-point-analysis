-- One-time setup: the CSV import loads `date` as text (character varying).
-- Convert it to a real DATE type so DATE_TRUNC / EXTRACT work in later queries.
ALTER TABLE sales_raw
ALTER COLUMN date TYPE date USING date::date;
