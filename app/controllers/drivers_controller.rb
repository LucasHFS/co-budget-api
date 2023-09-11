# frozen_string_literal: true

class DriversController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user!, only: %i[update destroy]

  def index
    @drivers = User.drivers.order(:name)
  end

  def create
    @driver = User.new(user_attributes)

    if @driver.save
      render :show, status: :created
    else
      render json: {
        error: { message: 'Erro de validação', details: @driver.errors.full_messages }
      }, status: :unprocessable_entity
    end
  end

  def update
    if @driver.update(user_attributes)
      render :show
    else
      render json: {
        error: {
          message: 'Erro de validação',
          details: @driver.errors.full_messages
        }
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @driver.destroy
      render json: {}, status: :no_content
    else
      render json: {
        error: {
          message: 'Erro de exclusão',
          details: 'não foi possivel excluir o motorista'
        }
      }, status: :unprocessable_entity
    end
  end

  private

  def driver_params
    params.require(:driver).permit(:name, :address, :phone, :gpsLink, :referencePoint, :district)
  end

  def find_user!
    @driver = User.find_by(id: params[:id])

    return if @driver

    render json: {
      error: {
        message: 'Não encontrado'
      }
    }, status: :not_found
  end

  def user_attributes
    {
      name: driver_params[:name],
      phone: driver_params[:phone],
      role: 'driver'
    }
  end
end
