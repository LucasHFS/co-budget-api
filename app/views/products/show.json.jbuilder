# frozen_string_literal: true

json.product do |json|
  json.partial! 'products/product', product: @product
end
