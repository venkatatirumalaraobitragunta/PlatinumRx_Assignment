-- Query B1: Revenue by each sales channel in 2021
SELECT 
    sales_channel,
    SUM(amount) AS total_revenue
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY sales_channel
ORDER BY total_revenue DESC;



-- Query B2: Top 10 most valuable customers of 2021
SELECT 
    cs.uid,
    c.name,
    SUM(cs.amount) AS total_spent
FROM clinic_sales cs
JOIN customer c 
    ON cs.uid = c.uid
WHERE YEAR(cs.datetime) = 2021
GROUP BY cs.uid, c.name
ORDER BY total_spent DESC
LIMIT 10;


-- Query B3: Month wise revenue, expense, profit & status
WITH monthly_revenue AS (
    SELECT 
        YEAR(datetime) AS yr,
        MONTH(datetime) AS mn,
        SUM(amount) AS revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = 2021
    GROUP BY YEAR(datetime), MONTH(datetime)
),
monthly_expenses AS (
    SELECT 
        YEAR(datetime) AS yr,
        MONTH(datetime) AS mn,
        SUM(amount) AS expense
    FROM expenses
    WHERE YEAR(datetime) = 2021
    GROUP BY YEAR(datetime), MONTH(datetime)
)
SELECT 
    COALESCE(r.yr, e.yr) AS yr,
    COALESCE(r.mn, e.mn) AS mn,
    COALESCE(r.revenue, 0) AS revenue,
    COALESCE(e.expense, 0) AS expense,
    COALESCE(r.revenue, 0) - COALESCE(e.expense, 0) AS profit,
    CASE 
        WHEN COALESCE(r.revenue, 0) - COALESCE(e.expense, 0) > 0 THEN 'profitable'
        ELSE 'not-profitable'
    END AS status
FROM monthly_revenue r
LEFT JOIN monthly_expenses e
    ON r.yr = e.yr AND r.mn = e.mn

UNION

SELECT 
    e.yr,
    e.mn,
    0 AS revenue,
    e.expense,
    -e.expense AS profit,
    'not-profitable'
FROM monthly_expenses e
LEFT JOIN monthly_revenue r
    ON r.yr = e.yr AND r.mn = e.mn
WHERE r.yr IS NULL

ORDER BY yr, mn;



-- Query B4: Most profitable clinic in each city for each month of 2021
-- Step 1: Revenue per clinic per month
WITH revenue_cte AS (
    SELECT 
        c.cid,
        c.city,
        YEAR(cs.datetime) AS yr,
        MONTH(cs.datetime) AS mn,
        SUM(cs.amount) AS revenue
    FROM clinic_sales cs
    JOIN clinics c ON cs.cid = c.cid
    WHERE YEAR(cs.datetime) = 2021
    GROUP BY c.cid, c.city, YEAR(cs.datetime), MONTH(cs.datetime)
),

-- Step 2: Expense per clinic per month
expense_cte AS (
    SELECT 
        c.cid,
        c.city,
        YEAR(e.datetime) AS yr,
        MONTH(e.datetime) AS mn,
        SUM(e.amount) AS expense
    FROM expenses e
    JOIN clinics c ON e.cid = c.cid
    WHERE YEAR(e.datetime) = 2021
    GROUP BY c.cid, c.city, YEAR(e.datetime), MONTH(e.datetime)
),

-- Step 3: Combine revenue and expenses (MySQL safe full join)
profit_cte AS (
    SELECT 
        r.cid,
        r.city,
        r.yr,
        r.mn,
        r.revenue,
        COALESCE(e.expense, 0) AS expense,
        r.revenue - COALESCE(e.expense, 0) AS profit
    FROM revenue_cte r
    LEFT JOIN expense_cte e
        ON r.cid = e.cid AND r.yr = e.yr AND r.mn = e.mn

    UNION ALL

    SELECT 
        e.cid,
        e.city,
        e.yr,
        e.mn,
        0 AS revenue,
        e.expense,
        -e.expense AS profit
    FROM expense_cte e
    LEFT JOIN revenue_cte r
        ON r.cid = e.cid AND r.yr = e.yr AND r.mn = e.mn
    WHERE r.cid IS NULL
),

-- Step 4: Rank clinics by profit inside each city per month
ranked AS (
    SELECT 
        *,
        RANK() OVER (PARTITION BY city, yr, mn ORDER BY profit DESC) AS rn
    FROM profit_cte
)

-- Step 5: Select most profitable clinic per city for each month
SELECT 
    city,
    yr,
    mn,
    cid,
    profit
FROM ranked
WHERE rn = 1
ORDER BY city, yr, mn;





-- Query B5: Second least profitable clinic per state per month (MySQL version)
-- Step 1: Revenue per clinic per month
WITH revenue_cte AS (
    SELECT 
        c.cid,
        c.state,
        YEAR(cs.datetime) AS yr,
        MONTH(cs.datetime) AS mn,
        SUM(cs.amount) AS revenue
    FROM clinic_sales cs
    JOIN clinics c ON cs.cid = c.cid
    WHERE YEAR(cs.datetime) = 2021
    GROUP BY c.cid, c.state, YEAR(cs.datetime), MONTH(cs.datetime)
),

-- Step 2: Expense per clinic per month
expense_cte AS (
    SELECT 
        c.cid,
        c.state,
        YEAR(e.datetime) AS yr,
        MONTH(e.datetime) AS mn,
        SUM(e.amount) AS expense
    FROM expenses e
    JOIN clinics c ON e.cid = c.cid
    WHERE YEAR(e.datetime) = 2021
    GROUP BY c.cid, c.state, YEAR(e.datetime), MONTH(e.datetime)
),

-- Step 3: Combine revenue + expenses (MySQL safe full join)
profit_cte AS (
    SELECT 
        r.cid,
        r.state,
        r.yr,
        r.mn,
        r.revenue,
        COALESCE(e.expense, 0) AS expense,
        r.revenue - COALESCE(e.expense, 0) AS profit
    FROM revenue_cte r
    LEFT JOIN expense_cte e
        ON r.cid = e.cid AND r.yr = e.yr AND r.mn = e.mn

    UNION ALL

    SELECT 
        e.cid,
        e.state,
        e.yr,
        e.mn,
        0 AS revenue,
        e.expense,
        -e.expense AS profit
    FROM expense_cte e
    LEFT JOIN revenue_cte r
        ON r.cid = e.cid AND r.yr = e.yr AND r.mn = e.mn
    WHERE r.cid IS NULL
),

-- Step 4: Rank clinics inside each STATE per MONTH from least to most profitable
ranked AS (
    SELECT 
        *,
        RANK() OVER (
            PARTITION BY state, yr, mn 
            ORDER BY profit ASC
        ) AS rn
    FROM profit_cte
)

-- Step 5: Pick the second least profitable clinic (rn = 2)
SELECT 
    state,
    yr,
    mn,
    cid,
    profit
FROM ranked
WHERE rn = 2
ORDER BY state, yr, mn;



