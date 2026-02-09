# frozen_string_literal: true

class Admin::Products::StocksController < Admin::BaseController
  load_and_authorize_resource :product
  authorize_resource class: false

  before_action :set_variant, only: %i[update modify]

  # GET /admin/product/:product_id/stocks
  def index
    @variants = @product.variants.sort_by_position
  end

  # PATCH/PUT /admin/product/:product_id/stocks/:id
  def update
    respond_to do |format|
      if @variant.update(variant_params)
        format.turbo_stream
      else
        format.turbo_stream { render status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/product/:product_id/stocks/:id/modify
  def modify
    count_on_hand = @variant.count_on_hand + variant_params[:modify_amount].to_i

    respond_to do |format|
      if @variant.update(count_on_hand:)
        format.turbo_stream
      else
        format.turbo_stream { render status: :unprocessable_entity }
      end
    end
  end

  private

  def set_variant
    @variant = @product.variants.find(params[:id])
  end

  def variant_params
    params.require(:variant).permit(:sku, :count_on_hand, :trackable, :backorderable, :modify_amount)
  end
end
