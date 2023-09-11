# frozen_string_literal: true

class SaleEventsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_sale_event!, only: %i[update destroy]

  def index
    @sale_events = SaleEvent.all.order(:date)
  end

  def create
    @sale_event = SaleEvent.new(sale_event_attributes)

    if @sale_event.save
      render :show, status: :created
    else
      render json: {
        error: {
          message: 'Erro de validação',
          details: sale_event.errors.full_messages
        }
      }, status: :unprocessable_entity
    end
  end

  def update
    if @sale_event.update(sale_event_attributes)
      render :show
    else
      render json: {
        error: {
          message: 'Erro de validação',
          details: @sale_event.errors.full_messages
        }
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @sale_event.destroy
      render json: {}, status: :no_content
    else
      render json: {
        error: {
          message: 'Erro de exclusão',
          details: 'não foi possivel excluir o evento'
        }
      }, status: :unprocessable_entity
    end
  end

  private

  def sale_events_param
    params.require(:sale_event).permit(:name, :date)
  end

  def find_sale_event!
    @sale_event = SaleEvent.find_by(id: params[:id])

    return if @sale_event

    render json: {
      error: {
        message: 'Não encontrado'
      }
    }, status: :not_found
  end

  def sale_event_attributes
    {
      name: sale_events_param[:name],
      # YYYY-MM-DD
      date: sale_events_param[:date]
    }
  end
end
