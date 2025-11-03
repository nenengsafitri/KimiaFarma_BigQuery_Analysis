-- Membuat tabel analisa Kimia Farma 2020–2023
CREATE OR REPLACE TABLE `iconic-vine-477007-j4.kimia_farma.kf_analisa` AS
SELECT
  t.transaction_id,
  t.date AS date,
  t.branch_id,
  kc.branch_name,
  kc.kota,
  kc.provinsi,
  kc.rating AS rating_cabang,
  t.customer_name,
  t.product_id,
  p.product_name,
  p.price AS actual_price,
  t.discount_percentage,
  
  -- Persentase Gross Laba berdasarkan harga obat
  CASE
    WHEN p.price <= 50000 THEN 0.10
    WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
    WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
    WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS persentase_gross_laba,
  
  -- Harga setelah diskon
  (p.price * (1 - (t.discount_percentage / 100))) AS nett_sales,
  
  -- Laba bersih
  (p.price * (1 - (t.discount_percentage / 100))) *
  CASE
    WHEN p.price <= 50000 THEN 0.10
    WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
    WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
    WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS nett_profit,
  
  t.rating AS rating_transaksi

FROM `iconic-vine-477007-j4.kimia_farma.kf_final_transaction` AS t
LEFT JOIN `iconic-vine-477007-j4.kimia_farma.kf_product` AS p
  ON t.product_id = p.product_id
LEFT JOIN `iconic-vine-477007-j4.kimia_farma.kf_kantor_cabang` AS kc
  ON t.branch_id = kc.branch_id
LEFT JOIN `iconic-vine-477007-j4.kimia_farma.kf_inventory` AS inv
  ON t.product_id = inv.product_id AND t.branch_id = inv.branch_id;
