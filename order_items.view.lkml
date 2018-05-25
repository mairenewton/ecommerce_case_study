view: order_items {
  sql_table_name: public.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: inventory_item_id {
    type: number
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }


###MEASURES###

  measure: total_sale_price {
    type: sum
    value_format_name: usd_0
    sql: ${TABLE}.sale_price ;;
  }

  measure: average_sale_price {
    type: average
    value_format_name: usd_0
    sql: ${TABLE}.sale_price ;;
  }

  measure: total_net_revenue {
    description: "net rev for completed orders"
    type: sum
    sql: ${TABLE}.sale_price;;
    value_format_name: usd_0
    filters: {
      field: status
      value: "Complete"
    }
  }


  measure: total_net_revenue_processing {
    description: "net rev for processed orders"
    type: sum
    sql: ${TABLE}.sale_price;;
    value_format_name: usd_0
    filters: {
      field: status
      value: "Processing"
    }
  }


  measure: total_margin {
    type: number
    value_format_name: usd_0
    sql: ${total_sale_price} - ${inventory_items.total_cost} ;;
  }


measure: margin_percent {
  type: number
  value_format: "#.00\%"
  sql: ${total_margin}/NULLIF(${total_net_revenue},0) ;;
}

  measure: count {
    type: count
  }

  measure: count_returned {
    description: "count of returned order items"
    type: count_distinct
    sql: ${id};;
    filters: {
      field: returned_date
      value: "-NULL"
    }
  }

  measure: item_return_rate {
    type: number
    value_format: "#.00\%"
    sql: 100.0 * ${count_returned}/NULLIF(${count},0) ;;

  }
  measure: average_spend_per_user {
    type: number
    value_format_name: usd
    sql: 1.0 * ${total_net_revenue}/NULLIF(${users.count}, 0) ;;

  }

}
