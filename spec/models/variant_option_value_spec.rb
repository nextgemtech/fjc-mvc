# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VariantOptionValue, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: variant_option_values
#
#  id                      :uuid             not null, primary key
#  position                :integer
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
