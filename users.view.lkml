view: users {
  sql_table_name: public.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: age_tier {
    type: tier
    tiers: [15,25,35,50,65]
    style: integer
    sql: ${age} ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
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

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: full_name {
    type:  string
    sql:  CONCAT(${first_name},' ',${last_name}) ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
    map_layer_name: us_states
  }

  dimension: traffic_source {
    type:  string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    hidden:  yes
    type: number
    sql: ${TABLE}.zip ;;
  }

  dimension: zipcode {
    type:  zipcode
    sql:  ${zip} ;;
  }

  dimension: is_new_users {
    type: yesno
    sql: DATEDIFF(day,${created_date},CURRENT_DATE)<= 90;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure:  count_users_returned {
    type: count
    filters: {
      field: order_items.is_returned
      value: "Yes"
    }
  }

#  measure: perc_user_returns {
#    type: number
#    sql: ${count_users_returned}/NULLIF(${count},0) ;;
#  }

  measure: avg_spend_per_user {
    type: number
    sql: ${order_items.total_sale_price}/NULLIF(${count},0) ;;
    drill_fields: [age_tier,gender,avg_spend_per_user]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      last_name,
      first_name,
      events.count,
      orders.count,
      user_data.count
    ]
  }
}
