# frozen_string_literal: true

# require 'rails_helper'
#
# RSpec.describe ProductOptionValue, type: :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end

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
