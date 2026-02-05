# frozen_string_literal: true

class OrdersController < BaseController
  load_and_authorize_resource

  def index
    @orders = Order.sort_by_latest.accessible_by(current_ability)
    @orders = @orders.where(order_statuses: { name: params[:status] }).joins(:order_status) if params[:status].present?
  end

  def show; end

  def sync
    respond_to do |format|
      if @order.update(user: current_user, guest_session_id: nil)
        format.turbo_stream if params[:redirect].blank?
        format.html { redirect_to orders_path }
      else
        format.turbo_stream { render status: :unprocessable_entity }
      end
    end
  end

  def cancel
    respond_to do |format|
      if @order.cancel_variant_release(cancelled_by: 'owner')
        format.turbo_stream if params[:redirect].blank?
        format.html { redirect_to orders_path }
      else
        format.turbo_stream { render status: :unprocessable_entity }
      end
    end
  end
end
