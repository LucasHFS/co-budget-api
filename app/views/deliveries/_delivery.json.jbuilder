# frozen_string_literal: true

json.call(delivery, :id, :instructions)
json.deliveryAddress delivery.delivery_address
json.status t("activerecord.attributes.delivery.state.#{delivery.state}")
json.deliveredAt delivery.delivered_at
json.driver delivery.driver

json.order do
  json.partial! 'orders/order', order: delivery.order
end
