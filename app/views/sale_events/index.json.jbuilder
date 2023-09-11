json.sale_events do |json|
  json.array! @sale_events, partial: 'sale_event', as: :sale_event
end
