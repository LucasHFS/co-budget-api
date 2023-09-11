# frozen_string_literal: true

class ClientsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user!, only: %i[update destroy]

  def index
    @clients = User.clients.order(:name)
  end

  def create
    @client = User.new(user_attributes)

    if @client.save
      render :show, status: :created
    else
      render json: {
        error: {
          message: 'Erro de validação',
          details: @client.errors.full_messages
        }
      }, status: :unprocessable_entity
    end
  end

  def update
    if @client.update(user_attributes)
      render :show
    else
      render json: {
        error: {
          message: 'Erro de validação',
          details: @client.errors.full_messages
        }
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @client.destroy
      render json: {}, status: :no_content
    else
      render json: {
        error: {
          message: 'Erro de exclusão',
          details: 'não foi possivel excluir o cliente'
        }
      }, status: :unprocessable_entity
    end
  end

  private

  def client_params
    params.require(:client).permit(:name, :address, :phone, :gpsLink, :referencePoint, :district)
  end

  def find_user!
    @client = User.find_by(id: params[:id])

    return if @client

    render json: {
      error: {
        message: 'Não encontrado'
      }
    }, status: :not_found
  end

  def user_attributes
    attributes = {
      name: client_params[:name],
      address: client_params[:address],
      gps_link: client_params[:gpsLink],
      phone: client_params[:phone],
      reference_point: client_params[:referencePoint],
      district: client_params[:district],
      role: 'client'
    }
  end
end
