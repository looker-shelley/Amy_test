view: inventory_items {
  sql_table_name: demo_db.inventory_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: cost {
    hidden: yes
    type: number
    sql: ${TABLE}.cost ;;
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

  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension_group: sold {
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
    sql: ${TABLE}.sold_at ;;
  }


  measure: count {
    type: count
    drill_fields: [id, products.item_name, products.id, order_items.count]
  }

  measure: total_cost {
    type: sum
    sql:  ${cost} ;;
  }

  measure: min_total_cost {
    type: min
    sql: ${cost} ;;
  }

  measure: total_profit {
    type:  sum
    sql: ${order_items.sale_price} - ${cost} ;;
  }

}
