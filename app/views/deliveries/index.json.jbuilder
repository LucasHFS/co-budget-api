# frozen_string_literal: true

json.deliveries_by_state do
  @deliveries_by_state.each do |state, deliveries|
    json.set! t("activerecord.attributes.delivery.state.#{state}") do
      json.deliveries do |json|
        json.array! deliveries, partial: 'delivery', as: :delivery
      end
    end
  end
end
