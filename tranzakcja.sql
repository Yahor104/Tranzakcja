SELECT 
    c.id AS ID_klienta,
    cr.id AS ID_samochodu,
    c.first_name,
    c.last_name,
    c.country,
    c.email,
    cr.marka,
    cr.model,
    cr.rok,
    CASE
        WHEN CAST(TRIM(cr.rok) AS UNSIGNED) BETWEEN 1940 AND 1979 THEN 1300
        WHEN CAST(TRIM(cr.rok) AS UNSIGNED) BETWEEN 1980 AND 1999 THEN 2200
        WHEN CAST(TRIM(cr.rok) AS UNSIGNED) BETWEEN 2000 AND 2015 THEN 2500
        ELSE 1500  
    END AS cena_bazowa_zł,
    CASE
        WHEN CAST(TRIM(cr.rok) AS UNSIGNED) BETWEEN 1940 AND 1979 THEN 1300
        WHEN CAST(TRIM(cr.rok) AS UNSIGNED) BETWEEN 1980 AND 1999 THEN 2200
        WHEN CAST(TRIM(cr.rok) AS UNSIGNED) BETWEEN 2000 AND 2015 THEN 2500
        ELSE 1500
    END
    * (CASE WHEN c.email LIKE '%apple%' THEN 1.4 ELSE 1 END)
    * (CASE WHEN c.country IN ('Polska','Chiny') THEN 0.7 ELSE 1 END)
    * (1 - LEAST(cnt.liczba_samochodow * 0.05, 0.5)) AS cena_po_rabatach_zł
FROM clients c
JOIN cars cr ON cr.client_id = c.id
JOIN (
    SELECT client_id, COUNT(*) AS liczba_samochodow
    FROM cars
    GROUP BY client_id
) cnt ON cnt.client_id = c.id
ORDER BY RAND()
LIMIT 1000;
