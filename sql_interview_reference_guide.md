# SQL Interview Reference Guide: Deduplication & State Extraction Patterns

Advanced SQL interview patterns for stripping away repetitive transactional logs or intermediary hops to extract a single definitive state per entity. Designed for data engineering roles (such as Tiger Analytics and Azure Databricks interviews).

---

## 1. First-Appearance / Cohort Acquisition Pattern

**Use Case:** Finding the exact initial month, date, or event when a customer or entity first appeared, discarding all subsequent repeat activities.

### Schema & Sample Data Setup
```sql
CREATE TABLE customer_sales (
    Month VARCHAR(20),
    Customer VARCHAR(10),
    QTY INT
);

INSERT INTO customer_sales VALUES ('Jan-21', 'C1', 20);
INSERT INTO customer_sales VALUES ('Jan-21', 'C2', 30);
INSERT INTO customer_sales VALUES ('Feb-21', 'C1', 10);
INSERT INTO customer_sales VALUES ('Feb-21', 'C3', 15);
INSERT INTO customer_sales VALUES ('Mar-21', 'C5', 19);
INSERT INTO customer_sales VALUES ('Mar-21', 'C4', 10);
INSERT INTO customer_sales VALUES ('Apr-21', 'C3', 13);
INSERT INTO customer_sales VALUES ('Apr-21', 'C5', 15);
INSERT INTO customer_sales VALUES ('Apr-21', 'C6', 10);
```

### Approach A: Using `MIN()` with Group By (Optimized for Spark SQL)
```sql
WITH first_seen AS (
    SELECT 
        Customer, 
        MIN(Month) AS first_month
    FROM customer_sales
    GROUP BY Customer
)
SELECT 
    first_month AS Month,
    COUNT(Customer) AS New_Customer_count
FROM first_seen
GROUP BY first_month
ORDER BY first_month;
```

### Approach B: Using Window Functions (`ROW_NUMBER()` with `rnk = 1`)
```sql
WITH ranked_sales AS (
    SELECT 
        Customer,
        Month,
        ROW_NUMBER() OVER (PARTITION BY Customer ORDER BY Month) AS rnk
    FROM customer_sales
)
SELECT 
    Month,
    COUNT(Customer) AS New_Customer_count
FROM ranked_sales
WHERE rnk = 1
GROUP BY Month
ORDER BY Month;
```

---

## 2. Boundary Node Extraction Pattern (Flight / Routing Chains)

**Use Case:** Tracing multi-leg networks or transit paths to isolate the absolute starting origin and final destination, canceling out intermediary connection nodes.

### Schema & Sample Data Setup
```sql
CREATE TABLE flights (
    cid INT,
    fid VARCHAR(10),
    origin VARCHAR(50),
    Destination VARCHAR(50)
);

INSERT INTO flights VALUES (1, 'f1', 'Del', 'Hyd');
INSERT INTO flights VALUES (1, 'f2', 'Hyd', 'Blr');
INSERT INTO flights VALUES (2, 'f3', 'Mum', 'Agra');
INSERT INTO flights VALUES (2, 'f4', 'Agra', 'Kol');
```

### Approach: Set-Based Anti-Join (`EXCEPT`)
```sql
WITH start_points AS (
    SELECT cid, origin 
    FROM flights
    EXCEPT
    SELECT cid, Destination AS origin 
    FROM flights
),
end_points AS (
    SELECT cid, Destination 
    FROM flights
    EXCEPT
    SELECT cid, origin AS Destination 
    FROM flights
)
SELECT 
    s.cid, 
    s.origin, 
    e.Destination
FROM start_points s
JOIN end_points e ON s.cid = e.cid;