-- Wstawienie 1000 polis z ceną bazową zależną od roku auta
INSERT INTO ubezpieczenia (ID_klienta, ID_samochodu, cena_bazowa_zł)
SELECT 
    c.id AS ID_klienta,
    a.id AS ID_samochodu,
    CASE
        WHEN CAST(TRIM(a.rok) AS UNSIGNED) BETWEEN 1940 AND 1979 THEN 1300
        WHEN CAST(TRIM(a.rok) AS UNSIGNED) BETWEEN 1980 AND 1999 THEN 2200
        WHEN CAST(TRIM(a.rok) AS UNSIGNED) BETWEEN 2000 AND 2015 THEN 2500
        ELSE 1500  -- minimalna cena bazowa, jeśli rok jest pusty lub poza zakresem
    END AS cena_bazowa_zł
FROM clients c
JOIN auta a ON a.client_id = c.id
ORDER BY RAND()
LIMIT 1000;

-- SELECT z wyliczeniem ceny po rabatach
SELECT 
    u.ID_ubezpieczenia,
    c.first_name,
    c.last_name,
    c.country,
    c.email,
    a.marka,
    a.model,
    a.rok,
    u.cena_bazowa_zł,
    u.cena_bazowa_zł
    * (CASE WHEN c.email LIKE '%apple%' THEN 1.4 ELSE 1 END)
    * (CASE WHEN c.country IN ('Polska','Chiny') THEN 0.7 ELSE 1 END)
    * (1 - LEAST(cnt.liczba_samochodow * 0.05, 0.5))
    AS cena_po_rabatach_zł
FROM ubezpieczenia u
JOIN clients c ON u.ID_klienta = c.id
JOIN auta a ON u.ID_samochodu = a.id
JOIN (
    SELECT client_id, COUNT(*) AS liczba_samochodow
    FROM auta
    GROUP BY client_id
) cnt ON cnt.client_id = c.id;
