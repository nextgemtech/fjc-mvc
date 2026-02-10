# frozen_string_literal: true

class Cart < ApplicationRecord
  # Relations
  belongs_to :variant
  belongs_to :user, optional: true
  belongs_to :guest_session, optional: true

  # Scopes
  scope :detailed,
        lambda {
          select('carts.*')
            # variants
            .select('variants.count_on_hand, variants.is_master, variants.price, ' \
                    'variants.trackable, variants.backorderable, variants.product_id')
            .joins(:variant)
            # products
            .select('products.name AS product_name, products.currency, ' \
                    'products.id AS product_id, products.discount_percent')
            .joins('INNER JOIN products ON products.id = variants.product_id')
            .order(created_at: :desc)
        }
  scope :checkout_condition,
        lambda {
          where('(variants.trackable AND variants.count_on_hand > 0 AND carts.qty <= variants.count_on_hand) ' \
                'OR (variants.trackable = FALSE OR (variants.trackable = TRUE AND variants.backorderable = TRUE))')
            .joins(:variant)
        }
  scope :variants_total,
        lambda {
          joins('INNER JOIN products ON products.id = variants.product_id')
            .joins(:variant)
            .sum('(variants.price * carts.qty) - ((variants.price * carts.qty) * ' \
                 '(products.discount_percent / 100.0))')
        }

  # Validations
  validates :qty, numericality: { greater_than: 0 }
  validates :guest_session, presence: true, unless: :user
  validates :user, presence: true, unless: :guest_session

  validate :validate_ownership

  def variant_pair
    variant.option_pair
  end

  def self.checkout(carts, guest_session:, user:)
    Order.transaction do
      order = Order.build
      order.order_status = OrderStatus.pending

      if user.present?
        order.user = user
      elsif guest_session.present?
        order.guest_session = guest_session
      else
        raise ActiveRecord::Rollback
      end

      order.save!

      carts.each do |cart|
        order_item = order.order_items.build
        order_item.variant = cart.variant
        order_item.price = cart.variant.price
        order_item.qty = cart.qty
        order_item.discount_percent = cart.variant.product.discount_percent
        order_item.save!

        cart.variant.update!(count_on_hand: cart.variant.count_on_hand - cart.qty) if cart.variant.trackable
        cart.destroy
      end

      order
    rescue StandardError => e
      logger.warn e
      nil
    end
  end

  private

  def validate_ownership
    return unless user.present? && guest_session.present?

    errors.add(:ownership, I18n.t('carts.validate.ownership_cant_be_both'))
  end
end

# == Schema Information
#
# Table name: carts
#
#  id               :uuid             not null, primary key
#  qty              :integer          default(1), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  guest_session_id :uuid
#  user_id          :uuid
#  variant_id       :uuid             not null
#
# Indexes
#
#  index_carts_on_guest_session_id                             (guest_session_id)
#  index_carts_on_user_id                                      (user_id)
#  index_carts_on_variant_id                                   (variant_id)
#  index_carts_on_variant_id_and_user_id_and_guest_session_id  (variant_id,user_id,guest_session_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (guest_session_id => guest_sessions.id)
#  fk_rails_...  (user_id => users.id)
#  fk_rails_...  (variant_id => variants.id)
#
