# frozen_string_literal: true

class Admin::OrdersController < Admin::BaseController
  load_and_authorize_resource

  def index
    @orders = Order.with_status.with_shipping_details.sort_by_latest.accessible_by(current_ability)
    @orders = @orders.where(order_statuses: { name: params[:status] }) if params[:status].present?

    @pagy, @orders = pagy(@orders)
  end

  def show; end

  def update_shipping_details
    if @order.update(shipping_detail_attributes: order_params[:shipping_detail_attributes])
      redirect_to admin_order_url(@order), notice: I18n.t('orders.shipping_details_updated')
    else
      render :show, status: :unprocessable_entity
    end
  end

  def update_logistic_details
    if @order.update(logistic_name: order_params[:logistic_name], logistic_url: order_params[:logistic_url],
                     logistic_ref: order_params[:logistic_ref])
      redirect_to admin_order_url(@order), notice: I18n.t('orders.logistic_details_updated')
    else
      render :show, status: :unprocessable_entity
    end
  end

  def update_internal_note
    if @order.update(internal_note: order_params[:internal_note])
      redirect_to admin_order_url(@order), notice: I18n.t('orders.internal_note_updated')
    else
      render :show, status: :unprocessable_entity
    end
  end

  def update_return_reason
    if @order.update(return_reason: order_params[:return_reason])
      redirect_to admin_order_url(@order), notice: I18n.t('orders.return_details_updated')
    else
      render :show, status: :unprocessable_entity
    end
  end

  def update_refund_reason
    if @order.update(refund_reason: order_params[:refund_reason], refund_amount: order_params[:refund_amount])
      redirect_to admin_order_url(@order), notice: I18n.t('orders.refund_details_updated')
    else
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    @order.destroy_variant_release

    respond_to do |format|
      format.turbo_stream if params[:redirect].blank?
      format.html { redirect_to admin_orders_url, notice: I18n.t('orders.destroyed') }
    end
  end

  def ship
    if @order.update(order_status: OrderStatus.to_ship)
      redirect_to admin_order_url(@order), notice: I18n.t('orders.updated')
    else
      render :show, status: :unprocessable_entity
    end
  end

  def recieve
    if @order.update(order_status: OrderStatus.to_recieve, logistic_name: order_params[:logistic_name],
                     logistic_url: order_params[:logistic_url], logistic_ref: order_params[:logistic_ref])
      redirect_to admin_order_url(@order), notice: I18n.t('orders.updated')
    else
      render :show, status: :unprocessable_entity
    end
  end

  def complete
    if @order.update(order_status: OrderStatus.completed)
      redirect_to admin_order_url(@order), notice: I18n.t('orders.updated')
    else
      render :show, status: :unprocessable_entity
    end
  end

  def cancel
    if @order.cancel_variant_release(cancelled_by: 'seller')
      redirect_to admin_order_url(@order), notice: I18n.t('orders.cancelled')
    else
      render :show, status: :unprocessable_entity
    end
  end

  def return
    if @order.return_variant_release(return_reason: order_params[:return_reason])
      redirect_to admin_order_url(@order), notice: I18n.t('orders.updated')
    else
      render :show, status: :unprocessable_entity
    end
  end

  def refund
    if @order.update(order_status: OrderStatus.refunded, refund_reason: order_params[:refund_reason],
                     refund_amount: order_params[:refund_amount])
      redirect_to admin_order_url(@order), notice: I18n.t('orders.updated')
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order)
          .permit(:logistic_name, :logistic_url, :logistic_ref,
                  :refund_reason, :return_reason, :refund_amount, :internal_note,
                  shipping_detail_attributes: %i[id fullname phone_no street barangay city state country postal_code])
  end
end
