# frozen_string_literal: true

json.order do |json|
  json.partial! 'orders/order', order: @order
end
