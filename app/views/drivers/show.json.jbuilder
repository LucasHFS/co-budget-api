# frozen_string_literal: true

json.driver do |json|
  json.partial! 'drivers/driver', driver: @driver
end
