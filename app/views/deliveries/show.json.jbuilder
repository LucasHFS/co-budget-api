# frozen_string_literal: true

json.deliveries do |json|
  json.partial! 'deliveries/delivery', delivery: @delivery
end
