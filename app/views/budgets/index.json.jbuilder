json.budgets do |json|
  json.array! @budgets, partial: 'budget', as: :budget
end
