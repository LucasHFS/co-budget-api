json.orders do
  json.array! @orders, partial: 'order', as: :order
end
