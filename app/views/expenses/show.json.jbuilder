# frozen_string_literal: true

json.expense do |json|
  json.partial! 'expenses/expense', expense: @expense
end
