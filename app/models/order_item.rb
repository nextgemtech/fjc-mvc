# frozen_string_literal: true

class OrderItem < ApplicationRecord
  # Relations
  belongs_to :order, optional: true
  belongs_to :variant, optional: true

  # Validations
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0, only_float: true }
  validates :qty, numericality: { greater_than: 0 }

  validate :check_variant_stock, if: :variant

  private

  def check_variant_stock
    return if !variant.trackable || (variant.trackable && variant.backorderable)

    if variant.count_on_hand.zero?
      errors.add(:variant, I18n.t('variants.validate.variant_out_of_stock'))
      return
    end

    return if variant.count_on_hand >= qty

    errors.add(:qty, I18n.t('carts.validate.qty_exceeds_stocks'))
  end
end

# == Schema Information
#
# Table name: order_items
#
#  id                     :uuid             not null, primary key
#  capture_product_name   :string
#  capture_variant_master :boolean          default(FALSE), not null
#  capture_variant_pair   :string
#  discount_percent       :integer          default(0), not null
#  price                  :decimal(10, 2)   not null
#  qty                    :integer          default(1), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  capture_product_id     :string
#  order_id               :uuid
#  variant_id             :uuid
#
# Indexes
#
#  index_order_items_on_order_id    (order_id)
#  index_order_items_on_variant_id  (variant_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#  fk_rails_...  (variant_id => variants.id)
#
