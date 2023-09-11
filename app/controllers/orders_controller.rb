# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_order!, only: %i[update destroy]
  before_action :find_orders, only: %i[register prepare send_order complete cancel]

  def by_state
    @orders_by_state = Order.all
    @orders_by_state = @orders_by_state.where(sale_event_id: params[:saleEventId]) if params[:saleEventId]
    @orders_by_state = @orders_by_state.group_by(&:state)
  end

  def index
    @orders = Order.all
    @orders = @orders.where(sale_event_id: params[:saleEventId]) if params[:saleEventId]
    @orders = @orders.sent if params[:sent]
  end

  def create
    result = Orders::Create.new(order_params).call

    if result.success?
      @order = result.record
      render :show, status: :created
    else
      render json: {
        error: { message: result.error[:message], details: result.error[:details] }
      }, status: :unprocessable_entity
    end
  end

  def update
    result = Orders::Update.new(@order, order_params).call
    if result.success?
      @order = result.record
      render :show
    else
      render json: {
        error: { message: result.error[:message], details: result.error[:details] }
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @order.destroy
      render json: {}, status: :no_content
    else
      render json: {
        error: {
          message: 'Erro de exclusão',
          details: 'não foi possivel excluir o pedido'
        }
      }, status: :unprocessable_entity
    end
  end

  def register
    @orders.each(&:register)
    render json: {}, status: :ok
  end

  def prepare
    @orders.each(&:prepare)
    render json: {}, status: :ok
  end

  def send_order
    @orders.each do |order|
      order.send_order
      order.deliveries.destroy_all
      order.create_delivery!(driver: User.find(params[:driverId]), sale_event: order.sale_event)
    end

    render json: {}, status: :ok
  end

  def complete
    @orders.each do |order|
      order.complete
      order.deliveries.each(&:complete)
    end

    render json: {}, status: :ok
  end

  def cancel
    @orders.each do |order|
      order.cancel
      order.deliveries.each(&:cancel)
    end

    render json: {}, status: :ok
  end

  private

  def order_params
    params.require(:order)
  end

  def find_order!
    @order = Order.find_by(id: params[:id] || params[:order_id])

    return if @order

    render json: {
      error: {
        message: 'Não encontrado'
      }
    }, status: :not_found
  end

  def find_orders
    @orders = Order.where(id: params[:ids])
  end
end
