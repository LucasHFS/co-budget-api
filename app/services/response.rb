# frozen_string_literal: true

class Response
  attr_reader :record, :error

  def initialize(success: true, error: nil, record: nil)
    @record    = record
    @success = error.blank?
    @error = error
  end

  def success?
    @success
  end
end
