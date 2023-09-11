# frozen_string_literal: true

class ApplicationController < ActionController::API
  respond_to :json
  include ActionController::MimeResponds

  rescue_from ActionController::ParameterMissing, with: :missing_parameters
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def missing_parameters(exception)
    respond_with_error(
      status: :unprocessable_entity,
      type: 'BadRequest',
      message: 'Missing parameters',
      details: [exception.message]
    )
  end

  def record_invalid(exception)
    respond_with_error(
      status: :conflict,
      type: 'ValidationError',
      message: 'Validation error',
      details: exception.record.errors.full_messages
    )
  end

  def record_not_found
    respond_with_error(
      status: :not_found,
      type: 'NotFoundError',
      message: 'Resource not found'
    )
  end

  def respond_with_error(status:, type:, message:, details: nil)
    response = { error: { type: type, message: message, details: details }.compact }
    render json: response, status: status
  end
end
