connection: "thelook"

include: "*.view.lkml"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
# explore: order_items {
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }

explore: order_items {
  from: order_items
  join: orders {
    type:  inner
    relationship:  many_to_one
    sql_on:  ${order_items.order_id} = ${orders.id} ;;
  }

  join: users {
    type:  inner
    relationship:  many_to_one
    sql_on: ${orders.user_id} = ${users.id} ;;
  }

}

explore: products {
  join:  inventory_items {
    view_label: "Inventory"
    type: inner
    relationship:  one_to_many
    sql_on: ${products.id} = ${inventory_items.product_id} ;;
  }

  join: order_items {
    type:  inner
    relationship:  one_to_many
    sql_on: ${inventory_items.id}= ${order_items.inventory_item_id} ;;
  }

  join: orders {
    type: inner
    relationship: many_to_one
    sql_on: ${order_items.order_id} = ${orders.id} ;;
  }

  join: users {
    type:  inner
    relationship:  many_to_one
    sql_on: ${orders.user_id} = ${users.id} ;;
  }
}
