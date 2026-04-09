SELECT user_id, room_no
FROM (
    SELECT 
        b.user_id,
        b.room_no,
        b.booking_date,
        ROW_NUMBER() OVER (
            PARTITION BY b.user_id 
            ORDER BY b.booking_date DESC
        ) AS rn
    FROM bookings b
) AS t
WHERE rn = 1;



-- Query 2: Booking_id and total billing amount in November 2021

SELECT 
    b.booking_id,
    SUM(bc.item_quantity * i.item_rate) AS total_billing_amount
FROM bookings b
JOIN booking_commercials bc 
    ON b.booking_id = bc.booking_id
JOIN items i 
    ON bc.item_id = i.item_id
WHERE YEAR(b.booking_date) = 2021
  AND MONTH(b.booking_date) = 11
GROUP BY b.booking_id;



-- Query 3: Bills raised in October 2021 with amount > 1000
SELECT 
    bc.bill_id,
    SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i 
    ON bc.item_id = i.item_id
WHERE YEAR(bc.bill_date) = 2021
  AND MONTH(bc.bill_date) = 10
GROUP BY bc.bill_id
HAVING bill_amount > 1000;



-- Query 4: Most and least ordered item of each month of 2021
WITH monthly_item_qty AS (
    SELECT 
        YEAR(bc.bill_date) AS yr,
        MONTH(bc.bill_date) AS mn,
        bc.item_id,
        i.item_name,
        SUM(bc.item_quantity) AS total_qty
    FROM booking_commercials bc
    JOIN items i 
        ON bc.item_id = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY YEAR(bc.bill_date), MONTH(bc.bill_date), bc.item_id, i.item_name
),
ranked AS (
    SELECT 
        yr,
        mn,
        item_id,
        item_name,
        total_qty,
        RANK() OVER (PARTITION BY yr, mn ORDER BY total_qty DESC) AS rk_most,
        RANK() OVER (PARTITION BY yr, mn ORDER BY total_qty ASC)  AS rk_least
    FROM monthly_item_qty
)
SELECT yr, mn, item_id, item_name, total_qty, 'MOST_ORDERED' AS category
FROM ranked
WHERE rk_most = 1

UNION ALL

SELECT yr, mn, item_id, item_name, total_qty, 'LEAST_ORDERED' AS category
FROM ranked
WHERE rk_least = 1

ORDER BY yr, mn, category;



-- Query 5: Second highest bill value of each month of 2021
WITH bill_totals AS (
    SELECT 
        bc.bill_id,
        b.user_id,
        YEAR(bc.bill_date) AS yr,
        MONTH(bc.bill_date) AS mn,
        SUM(bc.item_quantity * i.item_rate) AS bill_amount
    FROM booking_commercials bc
    JOIN items i 
        ON bc.item_id = i.item_id
    JOIN bookings b
        ON bc.booking_id = b.booking_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY bc.bill_id, b.user_id, YEAR(bc.bill_date), MONTH(bc.bill_date)
),
ranked_bills AS (
    SELECT 
        bill_id,
        user_id,
        yr,
        mn,
        bill_amount,
        RANK() OVER (
            PARTITION BY yr, mn 
            ORDER BY bill_amount DESC
        ) AS rn
    FROM bill_totals
)
SELECT 
    rb.yr,
    rb.mn,
    rb.bill_id,
    rb.bill_amount,
    u.name AS customer_name
FROM ranked_bills rb
JOIN users u
    ON rb.user_id = u.user_id
WHERE rn = 2
ORDER BY yr, mn;



