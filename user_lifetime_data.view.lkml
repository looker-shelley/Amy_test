view: user_lifetime_data {
  derived_table: {
    sql: select users.id
      , count(distinct orders.id) as "order_count"
      , sum(order_items.sale_price) as "total_revenue"
      , min(orders.created_at) as "first_order"
      , max(orders.created_at) as "last_order"
      from users
      inner join orders
      on users.id = orders.user_id
      inner join order_items
      on orders.id = order_items.order_id
      group by users.id
       ;;
  }

  measure: count {
    hidden:  yes
    type: count
    drill_fields: [detail*]
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: order_count {
    hidden: yes
    type: number
    sql: ${TABLE}.order_count ;;
  }

  measure: order_cnt {
    type: sum
    sql: ${order_count} ;;
  }

  dimension: order_count_tier {
    type: tier
    tiers: [1,2,5,9]
    style: integer
    sql: ${order_count} ;;
  }

  measure: avg_order_count {
    type: average
    sql: ${order_count} ;;
  }

  dimension: total_revenue {
    hidden: yes
    type: number
    sql: ${TABLE}.total_revenue ;;
  }

  measure: total_rev {
    type: sum
    sql: ${total_revenue} ;;
  }

  dimension: total_revenue_tier {
    type: tier
    tiers: [5,20,50,100,500,1000]
    style: relational
    sql: ${total_revenue} ;;
  }

  measure: avg_revenue {
    type: average
    sql:  ${total_revenue} ;;
  }

  dimension_group: first_order {
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
    sql: ${TABLE}.first_order ;;
  }


  dimension_group: last_order {
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
    sql: ${TABLE}.last_order ;;
  }

  dimension: days_since_last_purchase {
    #hidden: yes
    type: number
    sql: DATEDIFF(day,${last_order_date},CURRENT_DATE) ;;
  }

  dimension:  is_active {
    type: yesno
    sql: ${days_since_last_purchase} < 90;;
  }

  measure: avg_days_since_last_purchase {
    type: average
    sql: ${days_since_last_purchase} ;;
  }

  dimension: is_repeat_customer {
    type: yesno
    sql: ${order_count} >1 ;;
  }

  set: detail {
    fields: [
      id,
      order_count,
      total_revenue,
      first_order_time,
      last_order_time,
      days_since_last_purchase
    ]
  }
}
