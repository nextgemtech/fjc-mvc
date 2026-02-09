# frozen_string_literal: true

class Admin::ProductOptionValuesController < Admin::BaseController
  load_and_authorize_resource

  # GET /admin/product_option_values/find_name
  def find_name
    @product_option_values = @product_option_values
                             .accessible_by(current_ability)
                             .find_by(
                               name: params[:name],
                               product_option_id: params[:product_option_id]&.strip&.humanize
                             )

    render json: @product_option_values
  end

  # private
  #
  # def product_option_value_params
  #   params.require(:product_option_value)
  #         .permit(:name)
  # end
end
