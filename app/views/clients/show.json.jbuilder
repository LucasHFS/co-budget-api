# frozen_string_literal: true

json.client do |json|
  json.partial! 'clients/client', client: @client
end
