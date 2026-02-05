# frozen_string_literal: true

class Order < ApplicationRecord
  # Relations
  belongs_to :order_status
  belongs_to :user, optional: true
  belongs_to :guest_session, optional: true
  belongs_to :payment_method, optional: true

  has_one :shipping_detail, as: :shippable, dependent: :destroy
  has_many :order_items, dependent: :destroy

  accepts_nested_attributes_for :shipping_detail

  # Scopes
  scope :sort_by_latest, -> { order(created_at: :desc) }
  scope :with_status, -> { select('orders.*, order_statuses.name AS status').joins(:order_status) }
  scope :placed, -> { where.not(placed_at: nil) }
  scope :placed_pending, -> { where(order_status: { name: 'pending' }).where.not(placed_at: nil).joins(:order_status) }
  scope :with_shipping_details,
        lambda {
          select('orders.*, shipping_details.fullname AS customer_name')
            .joins("LEFT JOIN shipping_details ON shipping_details.shippable_type = 'Order' " \
                   'AND shipping_details.shippable_id = orders.id')
        }

  # validations
  validates :payment_method, presence: true, if: :placed_at
  validates :shipping_detail, presence: true, if: :placed_at

  validate :validate_ownership

  def subtotal
    order_items.sum('order_items.qty * order_items.price')
  end

  def discounted_price
    order_items.sum('(order_items.price * order_items.qty) * (order_items.discount_percent / 100.0)')
  end

  def total
    order_items.sum('(order_items.qty * order_items.price) - ((order_items.price * order_items.qty) * ' \
                    '(order_items.discount_percent / 100.0))') - shipping_fee
  end

  def cancel_variant_release(cancelled_by:)
    Order.transaction do
      update!(order_status: OrderStatus.cancelled, cancelled_at: Time.current, cancelled_by:)
      variant_release
      self
    rescue StandardError => e
      logger.warn e
      nil
    end
  end

  def return_variant_release(return_reason:)
    Order.transaction do
      update!(order_status: OrderStatus.returned, return_reason:)
      variant_release
      self
    rescue StandardError => e
      logger.warn e
      nil
    end
  end

  def destroy_variant_release
    Order.transaction do
      variant_release
      destroy
      self
    rescue StandardError => e
      logger.warn e
      nil
    end
  end

  def validate_ownership
    return unless user.present? && guest_session.present?

    errors.add(:ownership, I18n.t('orders.validate.ownership_cant_be_both'))
  end

  private

  def variant_release
    items = order_items.where(variant: { trackable: true }).joins(:variant)
    items.each do |item|
      item.variant.update!(count_on_hand: item.variant.count_on_hand + item.qty)
    end
  end
end

# == Schema Information
#
# Table name: orders
#
#  id                :uuid             not null, primary key
#  cancelled_at      :datetime
#  cancelled_by      :text
#  internal_note     :text
#  logistic_name     :string
#  logistic_ref      :string
#  logistic_url      :string
#  placed_at         :datetime
#  refund_amount     :decimal(10, 2)
#  refund_reason     :text
#  return_reason     :text
#  shipping_fee      :decimal(10, 2)   default(0.0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  guest_session_id  :uuid
#  order_status_id   :uuid             not null
#  payment_method_id :uuid
#  user_id           :uuid
#
# Indexes
#
#  index_orders_on_guest_session_id   (guest_session_id)
#  index_orders_on_order_status_id    (order_status_id)
#  index_orders_on_payment_method_id  (payment_method_id)
#  index_orders_on_user_id            (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (guest_session_id => guest_sessions.id)
#  fk_rails_...  (order_status_id => order_statuses.id)
#  fk_rails_...  (payment_method_id => payment_methods.id)
#  fk_rails_...  (user_id => users.id)
#
