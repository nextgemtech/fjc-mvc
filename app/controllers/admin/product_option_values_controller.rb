# frozen_string_literal: true

class Admin::ProductOptionValuesController < Admin::BaseController
  load_and_authorize_resource

  # POST /admin/product_option_values
  def create
    @product_option_value = ProductOptionValue.new(product_option_value_params)

    if @product_option_value.save
      render json: @product_option_value, status: :ok
    else
      render json: @product_option_value.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def product_option_value_params
    params.require(:product_option_value).permit(:name, :product_option_id)
  end
end
