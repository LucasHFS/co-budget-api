# frozen_string_literal: true

json.saleEvent do |json|
  json.partial! 'sale_events/sale_event', sale_event: @sale_event
end
