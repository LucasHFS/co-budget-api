class DeliveriesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_deliveries, only: %i[register start complete cancel]

  def index
    @deliveries_by_state = Delivery.all
    @deliveries_by_state = @deliveries_by_state.includes(:order).where(sale_event_id: params[:saleEventId]) if params[:saleEventId]
    @deliveries_by_state = @deliveries_by_state.group_by(&:state)
  end

  def update
    if @delivery.update(delivery_params)
      render json: @delivery, status: :ok
    else
      render json: {
        error: {
          message: 'Erro de atualização',
          details: @delivery.errors.full_messages
        }
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @delivery.destroy
      render json: {}, status: :no_content
    else
      render json: {
        error: {
          message: 'Erro de exclusão',
          details: 'não foi possivel excluir a entrega'
        }
      }, status: :unprocessable_entity
    end
  end

  def register
    @deliveries.each(&:register)
    render json: {}, status: :ok
  end

  def start
    @deliveries.each(&:start)

    render json: {}, status: :ok
  end

  def complete
    @deliveries.each(&:complete)
    render json: {}, status: :ok
  end

  def cancel
    @deliveries.each(&:cancel)
    render json: {}, status: :ok
  end

  private

  def find_deliveries
    @deliveries = Delivery.where(id: params[:ids])
  end

  def delivery_params
    params.require(:delivery).permit(:user_id, :delivery_address, :instructions)
  end
end
