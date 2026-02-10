# frozen_string_literal: true

FactoryBot.define do
  factory :order_item do
    order { create(:order) }
    variant { create(:variant) }
    qty { 1 }
    price { Faker::Commerce.price }
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
