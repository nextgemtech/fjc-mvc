# frozen_string_literal: true

class CartsController < BaseController
  load_and_authorize_resource

  def index
    @carts = Cart.detailed.accessible_by(current_ability)
  end

  def update
    respond_to do |format|
      if @cart.update(cart_params)
        format.turbo_stream
      else
        format.turbo_stream { render :error, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @cart.destroy
  end

  def sync
    respond_to do |format|
      if (@common_cart = current_user.carts.find_by(variant_id: @cart.variant_id)).present?
        ActiveRecord::Base.transaction do
          @common_cart.update(qty: @cart.qty + @common_cart.qty)
          @cart.destroy
        rescue ActiveRecord::RecordInvalid
          format.turbo_stream { render :error, :unprocessable_entity }
        else
          format.turbo_stream { render :sync_common }
        end
      elsif @cart.update(user: current_user, guest_session: nil)
        format.turbo_stream
      else
        format.turbo_stream { render :error, :unprocessable_entity }
      end
    end
  end

  def sync_all; end

  def variant_dropdown; end

  def proceed_checkout
    @carts = @carts.accessible_by(current_ability, :proceed_checkout)
    @carts = @carts.where(id: params[:ids]) if params[:ids].present?

    if @carts.count.positive? && (order = Cart.checkout(@carts, user: current_user, guest_session:)).present?
      redirect_to checkout_url(order), notice: I18n.t('checkouts.created')
    else
      redirect_to carts_path, alert: I18n.t('error.something_went_wrong')
    end
  end

  def total
    @carts = Cart.accessible_by(current_ability, :total)
    @carts = @carts.where(id: params[:ids]) if params[:ids].present?
    @total = @carts.variants_total
  end

  def bulk_delete
    @carts = Cart.accessible_by(current_ability, :bulk_delete)
    @carts = @carts.where(id: params[:ids]) if params[:ids].present?
    @carts = @carts.destroy_all
  end

  def count
    @carts = Cart.joins(:variant).accessible_by(current_ability, :count)
    @cart_count = @carts.count
    cookies.signed[:cart_count] = @cart_count
  end

  private

  def cart_params
    params.require(:cart).permit(:qty, :variant_id)
  end
end
