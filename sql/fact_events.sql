SELECT
  user_pseudo_id AS user_id,
  event_name,
  (
    SELECT value.string_value
    FROM UNNEST(event_params)
    WHERE key = 'transaction_id'
  ) AS transaction_id,
  date(timestamp_micros(event_timestamp)) AS event_date,
  timestamp_micros(event_timestamp) AS event_ts,
  (
    SELECT value.int_value
    FROM UNNEST(event_params)
    WHERE key = 'engagement_time_msec'
  ) AS engagement_time_msec,
  (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id')
    AS session_id,
  device.category AS device,
  geo.country,
  geo.region,
  geo.city,
  traffic_source.name AS traffic_sname,
  traffic_source.medium AS traffic_smedium,
  traffic_source.source AS traffic_source,
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE
  event_name IN (
    'view_item', 'select_item', 'add_to_cart', 'begin_checkout',
    'add_shipping_info', 'add_payment_info', 'purchase', 'view_item_list',
    'view_search_results', 'session_start', 'first_visit', 'user_engagement')
