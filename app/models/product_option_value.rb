# frozen_string_literal: true

class ProductOptionValue < ApplicationRecord
  belongs_to :product_option

  has_many :variant_option_values, dependent: :destroy

  # Attachments
  has_one_attached :image do |attachable|
    attachable.variant :small, resize_to_limit: [250, 250]
  end

  normalizes :name, with: -> { _1.strip }

  validates :name, presence: true
  validates :name, uniqueness: { scope: %i[product_option_id], case_sensitive: false }
end

# == Schema Information
#
# Table name: product_option_values
#
#  id                :bigint           not null, primary key
#  name              :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  product_option_id :uuid             not null
#
# Indexes
#
#  index_product_option_values_on_name_and_product_option_id  (name,product_option_id) UNIQUE
#  index_product_option_values_on_product_option_id           (product_option_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_option_id => product_options.id)
#
