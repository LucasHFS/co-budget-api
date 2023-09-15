# frozen_string_literal: true

class ApplicationController < ActionController::API
  respond_to :json
  include ActionController::MimeResponds

  rescue_from ActionController::ParameterMissing, with: :missing_parameters
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_foreign_key

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
      message: 'Recurso não encontrado'
    )
  end

  def invalid_foreign_key
    respond_with_error(
      status: :unprocessable_entity,
      type: 'BadRequest',
      message: 'Erro de exclusão'
    )
  end

  def respond_with_error(status:, type:, message:, details: nil)
    response = { error: { type:, message:, details: }.compact }
    render json: response, status:
  end
end
