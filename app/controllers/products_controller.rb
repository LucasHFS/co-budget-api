# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_product!, only: %i[update destroy]

  def index
    @products = Product.all.order(:name)
  end

  def create
    @product = Product.new(product_attributes)

    if @product.save
      render :show, status: :created
    else
      render json: {
        error: {
          message: 'Erro de validação',
          details: @product.errors.full_messages
        }
      }, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_attributes)
      render :show
    else
      render json: {
        error: {
          message: 'Erro de validação',
          details: @product.errors.full_messages
        }
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @product.destroy
      render json: {}, status: :no_content
    else
      render json: {
        error: {
          message: 'Erro de exclusão',
          details: ['não foi possivel excluir o produto']
        }
      }, status: :unprocessable_entity
    end
  end

  private

  def products_param
    params.require(:product).permit(:name, :price)
  end

  def find_product!
    @product = Product.find_by(id: params[:id])

    return if @product

    render json: {
      error: {
        message: 'Não encontrado'
      }
    }, status: :not_found
  end

  def product_attributes
    attributes = {
      name: products_param[:name],
      price_in_cents: products_param[:price].to_f * 100
    }
  end
end
