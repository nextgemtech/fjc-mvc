# frozen_string_literal: true

class Variant < ApplicationRecord
  acts_as_list scope: %i[product_id is_master]

  # Relations
  belongs_to :product

  has_many :variant_option_values, dependent: :destroy
  has_many :product_option_values, through: :variant_option_values, dependent: :destroy
  has_many :carts, dependent: :destroy
  has_many :order_items, dependent: :nullify

  # Nested form
  accepts_nested_attributes_for :variant_option_values

  # Scopes
  scope :sort_by_position, -> { order(position: :asc) }
  scope :not_master, -> { where(is_master: false) }
  scope :master, -> { where(is_master: true) }
  scope :stock_sum, -> { sum(:count_on_hand) }

  # Validations
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0, only_float: true }
  validates :cost, numericality: { greater_than_or_equal_to: 0, only_float: true }, allow_nil: true
  validates :variant_option_values, presence: true, unless: :is_master
  validates :count_on_hand, presence: true
  validates :option_value_signature, uniqueness: { scope: :product_id }

  validate :only_one_master, if: :only_one_master_condition
  validate :product_supports_variant, unless: :is_master

  # Generators
  before_validation :set_option_value_signature, unless: :is_master
  before_destroy :capture_order_item_variants, prepend: true

  after_destroy :capture_price
  after_save :capture_price, if: :price_previously_changed?

  def option_pair
    Rails.cache.fetch("#{id}/#{option_value_signature}/option_pair", expires_in: 12.hours) do
      product_option_values
        .order('product_options.position asc')
        .joins(:product_option)
        .joins('INNER JOIN options ON options.id = product_options.option_id')
        .pluck(Arel.sql("CONCAT_WS(': ', options.display_name, product_option_values.name)")).join(', ')
    end
  end

  private

  # For generators
  def set_option_value_signature
    ids = variant_option_values.map(&:product_option_value_id).sort
    self.option_value_signature = ids.join('_')
  end

  def capture_order_item_variants
    order_items.each do |order_item|
      order_item.update(
        {
          capture_product_name: product.name,
          capture_product_id: product.id,
          capture_product_currency: product.currency,
          capture_variant_pair: option_pair,
          capture_variant_master: is_master
        }
      )
    end
  end

  def capture_price
    variants = product.variants
    no_variant_records = variants.not_master.count.zero?
    captured = variants.where(is_master: no_variant_records)

    product.update(lowest_price: captured.minimum(:price), highest_price: captured.maximum(:price))
  end

  # For validations
  def only_one_master
    return unless product.variants.exists?(is_master: true)

    errors.add(:master, I18n.t('variants.validate.only_one_master'))
  end

  def only_one_master_condition
    (new_record? && is_master) || (is_master_changed? && is_master_was) || false
  end

  def product_supports_variant
    return if product.has_variant

    errors.add(:product, I18n.t('variants.validate.variant_not_supported'))
  end
end

# == Schema Information
#
# Table name: variants
#
#  id                     :uuid             not null, primary key
#  backorderable          :boolean          default(FALSE), not null
#  cost                   :decimal(10, 2)
#  count_on_hand          :integer          default(0), not null
#  is_master              :boolean          default(FALSE), not null
#  option_value_signature :string
#  position               :integer
#  price                  :decimal(10, 2)   not null
#  sku                    :string
#  trackable              :boolean          default(TRUE), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  product_id             :uuid             not null
#
# Indexes
#
#  index_variants_on_position                               (position)
#  index_variants_on_product_id                             (product_id)
#  index_variants_on_product_id_and_option_value_signature  (product_id,option_value_signature) UNIQUE
#  index_variants_on_sku                                    (sku)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#
