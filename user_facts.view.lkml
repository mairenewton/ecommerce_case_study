view: user_facts {
  derived_table: {
    sql: SELECT
        order_items.user_id as user_id
        , COUNT(DISTINCT order_items.order_id) as lifetime_orders
        , SUM(order_items.sale_price) AS lifetime_revenue
        , MIN(NULLIF(order_items.created_at,0)) as first_order
        , MAX(NULLIF(order_items.created_at,0)) as latest_order
        , COUNT(DISTINCT DATE_TRUNC('month', NULLIF(order_items.created_at,0))) as number_of_distinct_months_with_orders
        , SUM(order_items.sale_price) AS order_value
      FROM order_items
      GROUP BY user_id
       ;;
    datagroup_trigger: ecommerce_case_study_default_datagroup
    sortkeys: ["user_id"]
    distribution: "user_id"
  }

  dimension_group: first_order {
    type: time
    timeframes: [date, week, month, year]
    sql: ${TABLE}.first_order ;;
  }

  dimension_group: latest_order {
    type: time
    timeframes: [date, week, month, year]
    sql: ${TABLE}.latest_order ;;
  }

  dimension: user_id {
    primary_key: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: order_value {
    type: number
    value_format_name: usd
    sql: ${TABLE}.order_value ;;
  }

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  dimension: distinct_months_with_orders {
    type: number
    sql: ${TABLE}.number_of_distinct_months_with_orders ;;
  }

  measure: average_order_value {
    type: average
    sql:${TABLE}.order_value ;;
  }

  measure: average_lifetime_revenue {
    type: average
    sql: ${lifetime_revenue} ;;
  }
}
