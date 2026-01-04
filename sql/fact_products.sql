SELECT
  date(timestamp_micros(event_timestamp)) AS event_date,
  timestamp_micros(event_timestamp) AS event_ts,
  event_name,
  user_pseudo_id AS user_id,
  (
    SELECT
      value.string_value
    FROM
      UNNEST(event_params)
    WHERE key = 'transaction_id'
  ) AS transaction_id,
  (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id')
    AS session_id,
  device.category AS device,
  geo.country,
  geo.region,
  geo.city,
  traffic_source.name AS traffic_sname,
  traffic_source.medium AS traffic_smedium,
  traffic_source.source AS traffic_source,
  i.item_id,
  i.item_name,
  i.price,
  i.quantity,
  safe_multiply(i.price, i.quantity) AS item_revenue,
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
  UNNEST(items) AS i
WHERE
  event_name IN (
    'view_item', 'select_item', 'add_to_cart', 'begin_checkout',
    'add_shipping_info', 'add_payment_info', 'purchase', 'view_item_list',
    'view_search_results')
