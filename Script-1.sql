select customer.first_name, address.address,SUM(payment.amount) as SUMpay,
case 
	WHEN PERCENT_RANK() OVER (ORDER BY SUM(payment.amount)desc ) <= 0.8 THEN 'А'
	WHEN PERCENT_RANK() OVER (ORDER BY SUM(payment.amount)desc ) <= 0.95 THEN 'B'
	else 'C'
end as ABCC
from customer
join payment on customer.customer_id = payment.customer_id
join address on customer.address_id = address.address_id 
group by  customer.customer_id, customer.first_name, address.address_id, address.address;

--Доля по распределению
SELECT  customer.first_name, address.address,SUM(payment.amount) as SUMpay,
        CUME_DIST() OVER (ORDER BY SUM(payment.amount) DESC) AS cume_dist, -- CUME_DIST (кумулятивное распределение)
    CASE     -- ABC-анализ через CUME_DIST
        WHEN CUME_DIST() OVER (ORDER BY SUM(payment.amount) DESC) <= 0.8 THEN 'A'  -- Топ 80%
        WHEN CUME_DIST() OVER (ORDER BY SUM(payment.amount) DESC) <= 0.95 THEN 'B' -- Следующие 15%
        ELSE 'C'                                                                   -- Остальные 5%
    END AS ABCC_cume
FROM customer
JOIN payment ON customer.customer_id = payment.customer_id
JOIN address ON customer.address_id = address.address_id 
GROUP BY customer.customer_id, customer.first_name, address.address_id, address.address;

-- Накопительный процент 
SELECT  customer.first_name, address.address,SUM(payment.amount) as SUMpay,
SUM(payment.amount) over (order by payment.amount DESC ) as total,
	ROUND(
		SUM(payment.amount) over (order by payment.amount DESC ) *100 /
			SUM(payment.amount) over(),0) as Prosent
FROM customer			
JOIN payment ON customer.customer_id = payment.customer_id
JOIN address ON customer.address_id = address.address_id 
GROUP BY customer.customer_id, customer.first_name, address.address_id, address.address;

 