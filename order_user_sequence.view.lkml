view: order_user_sequence {
  derived_table: {
    sql: select user_id
      , orders.id as orders_id
      , created_at
      , ROW_NUMBER() Over (Partition by user_id Order by created_at) as sequence_num
      , LAG(created_at) Over( Partition by user_id Order by created_at) as prev_created_at
      , LEAD (created_at) Over( Partition by user_id Order by created_at) as next_created_at
      from orders
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: orders_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.orders_id ;;
  }

  dimension_group: created_at {
    type: time
    sql: ${TABLE}.created_at ;;
  }

  dimension: sequence_num {
    type: number
    sql: ${TABLE}.sequence_num ;;
  }

  dimension_group: prev_created_at {
    type: time
    sql: ${TABLE}.prev_created_at ;;
  }

  dimension: has_subsequent_order {
    type: yesno
    sql: ${next_created_at_date} is not null ;;
  }

  dimension_group: next_created_at {
    type: time
    sql: ${TABLE}.next_created_at ;;
  }

  dimension: days_between_orders {
    type: number
    sql: DATEDIFF(day,${prev_created_at_date},${created_at_date}) ;;
  }

  measure: average_days_between_orders {
    type: average
    sql:  ${days_between_orders} ;;
  }

  dimension: is_first_purchase {
    type: yesno
    sql: ${sequence_num} = 1 ;;
  }

  measure: total_sequence_num {
    hidden: yes
    type: sum
    sql: ${sequence_num};;
  }

  measure: has_lifetime_subsequent_order {
    type: yesno
    sql: ${total_sequence_num} > 1;;
  }

  measure: 60_day_repeat_purchase_count {
    type: count_distinct
    sql: CASE WHEN ${days_between_orders} < 60 THEN ${user_id} END ;;
  }

  measure: user_count {
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: 60_day_repeat_purchase_rate {
    type: number
    sql:  1.0 * ${60_day_repeat_purchase_count}/NULLIF(${user_count},0) ;;
    value_format: "#.0000,-#.0000"
  }

  set: detail {
    fields: [user_id, orders_id, created_at_time, sequence_num]
  }
}

#explore:  order_user_sequence2 {}
