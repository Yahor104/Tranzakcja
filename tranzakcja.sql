-- 1. Tworzenie tabeli ubezpieczenia
CREATE TABLE IF NOT EXISTS ubezpieczenia (
    ID_ubezpieczenia INT PRIMARY KEY AUTO_INCREMENT,
    ID_klienta INT,
    ID_samochodu INT,
    cena_bazowa_zł DECIMAL(10,2),
    FOREIGN KEY (ID_klienta) REFERENCES clients(id),
    FOREIGN KEY (ID_samochodu) REFERENCES cars(id)
);

-- 2. Wstawienie 1000 polis z ceną bazową zależną od roku auta
INSERT INTO ubezpieczenia (ID_klienta, ID_samochodu, cena_bazowa_zł)
SELECT 
    c.id AS ID_klienta,
    cr.id AS ID_samochodu,
    CASE
        WHEN CAST(TRIM(cr.rok) AS UNSIGNED) BETWEEN 1940 AND 1979 THEN 1300
        WHEN CAST(TRIM(cr.rok) AS UNSIGNED) BETWEEN 1980 AND 1999 THEN 2200
        WHEN CAST(TRIM(cr.rok) AS UNSIGNED) BETWEEN 2000 AND 2015 THEN 2500
        ELSE 1500  -- minimalna cena bazowa, jeśli rok jest pusty lub poza zakresem
    END AS cena_bazowa_zł
FROM clients c
JOIN cars cr ON cr.client_id = c.id
ORDER BY RAND()
LIMIT 1000;

-- 3. SELECT z wyliczeniem ceny po rabatach
SELECT 
    u.ID_ubezpieczenia,
    c.first_name,
    c.last_name,
    c.country,
    c.email,
    cr.marka,
    cr.model,
    cr.rok,
    u.cena_bazowa_zł,
    u.cena_bazowa_zł
    * (CASE WHEN c.email LIKE '%apple%' THEN 1.4 ELSE 1 END)
    * (CASE WHEN c.country IN ('Polska','Chiny') THEN 0.7 ELSE 1 END)
    * (1 - LEAST(cnt.liczba_samochodow * 0.05, 0.5))
    AS cena_po_rabatach_zł
FROM ubezpieczenia u
JOIN clients c ON u.ID_klienta = c.id
JOIN cars cr ON u.ID_samochodu = cr.id
JOIN (
    SELECT client_id, COUNT(*) AS liczba_samochodow
    FROM cars
    GROUP BY client_id
) cnt ON cnt.client_id = c.id;
