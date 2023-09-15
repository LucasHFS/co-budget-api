# frozen_string_literal: true

json.budget do |json|
  json.partial! 'budgets/budget', budget: @budget
end
