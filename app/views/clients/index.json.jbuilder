json.clients do |json|
  json.array! @clients, partial: 'client', as: :client
end
