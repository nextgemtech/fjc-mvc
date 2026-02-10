# frozen_string_literal: true

class Admin::Products::VariantsController < Admin::BaseController
  load_and_authorize_resource :product
  load_and_authorize_resource through: :product

  # GET /admin/products/:product_id/variants
  def index
    @variants = @variants.sort_by_position.accessible_by(current_ability)
  end

  # GET /admin/products/:product_id/variants/:id
  def show; end

  # GET /admin/products/:product_id/variants/new
  def new; end

  # POST /admin/products/:product_id/variants
  def create
    @variant = Variant.new(variant_params)

    if @variant.save
      redirect_to admin_product_variants_url(@product), notice: I18n.t('variants.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admin/products/:product_id/variants/:id
  def update
    respond_to do |format|
      if @variant.update(variant_params)
        format.html { redirect_to admin_product_variants_url(@product), notice: I18n.t('variants.updated') }
        format.turbo_stream
      else
        format.html { render :show, status: :unprocessable_entity }
        format.turbo_stream { render status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/products/:product_id/variants/:id
  def destroy
    @variant.destroy
  end

  # PATCH /admin/products/:product_id/variants/:id/position
  def position
    @variant.insert_at(variant_params[:position].to_i)

    head :ok
  end

  private

  def variant_params
    params.require(:variant)
          .permit(:name, :alternative_name, :cost, :price, :count_on_hand,
                  :position, :trackable, :backorderable, :sku, :product_id,
                  variant_option_values_attributes: %i[
                    id
                    variant_id
                    product_option_value_id
                  ])
  end
end
