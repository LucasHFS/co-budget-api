# frozen_string_literal: true

json.call(order, :id, :price)
json.status t("activerecord.attributes.order.state.#{order.state}")
json.client order.client, partial: 'clients/client', as: :client
json.notes order.notes
json.isDelivery order.is_delivery

json.products do |json|
  json.array! order.line_items do |line_item|
    json.id line_item.product.id
    json.name line_item.product.name
    json.price line_item.unit_price
    json.quantity line_item.quantity
  end
end
