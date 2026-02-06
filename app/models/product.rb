# frozen_string_literal: true

class Product < ApplicationRecord
  # Constants
  MAX_IMAGES = 10
  ALLOWED_IMAGE_TYPES = %w[image/png image/jpg image/jpeg].freeze

  # Attachments & Rich text
  has_rich_text :description

  has_many_attached :images do |attachable|
    attachable.variant :small, resize_to_limit: [100, 100]
    attachable.variant :thumb, resize_to_limit: [320, 320]
  end
  has_one_attached :thumbnail do |attachable|
    attachable.variant :small, resize_to_limit: [100, 100]
    attachable.variant :card, resize_to_limit: [320, 320]
  end

  # Relations
  has_one :seo, dependent: :destroy

  has_many :variants, dependent: :destroy
  has_many :product_options, dependent: :destroy
  has_many :options, through: :product_options, dependent: :destroy
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories, dependent: :destroy

  # Scoped relations
  has_one :master_variant, lambda {
    where(is_master: true)
  }, class_name: 'Variant', inverse_of: :product, dependent: :destroy

  # Nested form
  accepts_nested_attributes_for :master_variant, :seo

  # Scopes
  scope :sort_by_latest, -> { order(created_at: :desc) }
  scope :sort_by_oldest, -> { order(created_at: :asc) }
  scope :base_on_date, lambda { |today = Date.current|
    where(available_on: ..today)
      .where('discontinue_on IS NULL OR discontinue_on > ?', today)
  }

  # Validations
  validates :name, :master_variant, :currency, presence: true
  validates :discount_percent, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :review_avg_rating, numericality: { in: 0..5 }
  validates :lowest_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :highest_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :thumbnail, content_type: ALLOWED_IMAGE_TYPES
  validates :images, content_type: ALLOWED_IMAGE_TYPES,
                     limit: { max: MAX_IMAGES, message: I18n.t('images.validate.max', max: MAX_IMAGES) }
end

# == Schema Information
#
# Table name: products
#
#  id                :uuid             not null, primary key
#  available_on      :date
#  currency          :string           default("PHP"), not null
#  discontinue_on    :date
#  discount_percent  :integer          default(0), not null
#  has_variant       :boolean          default(FALSE), not null
#  highest_price     :decimal(10, 2)
#  lowest_price      :decimal(10, 2)
#  name              :string           not null
#  order_must_login  :boolean          default(FALSE), not null
#  promotable        :boolean          default(TRUE), not null
#  review_avg_rating :decimal(1, 1)    default(0.0)
#  review_count      :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_products_on_available_on    (available_on)
#  index_products_on_discontinue_on  (discontinue_on)
#  index_products_on_highest_price   (highest_price)
#  index_products_on_lowest_price    (lowest_price)
#  index_products_on_name            (name)
#
