json.orders_by_state do
  @orders_by_state.each do |state, orders|
    json.set! t("activerecord.attributes.order.state.#{state}") do
      json.orders do |json|
        json.array! orders, partial: 'order', as: :order
      end
    end
  end
end
