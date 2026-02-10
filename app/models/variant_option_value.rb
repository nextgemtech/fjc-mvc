# frozen_string_literal: true

class VariantOptionValue < ApplicationRecord
  # Relations
  belongs_to :variant
  belongs_to :product_option_value

  validates :variant_id, uniqueness: { scope: %i[product_option_value_id] }
end

# == Schema Information
#
# Table name: variant_option_values
#
#  id                      :uuid             not null, primary key
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  product_option_value_id :bigint           not null
#  variant_id              :uuid             not null
#
# Indexes
#
#  idx_vov_unique_variant_id_and_product_option_value_id   (variant_id,product_option_value_id) UNIQUE
#  index_variant_option_values_on_product_option_value_id  (product_option_value_id)
#  index_variant_option_values_on_variant_id               (variant_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_option_value_id => product_option_values.id)
#  fk_rails_...  (variant_id => variants.id)
#
