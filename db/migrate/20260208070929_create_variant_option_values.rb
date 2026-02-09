# frozen_string_literal: true

class CreateVariantOptionValues < ActiveRecord::Migration[7.0]
  def change
    create_table :variant_option_values, id: :uuid do |t|
      t.references :variant, null: false, foreign_key: true, type: :uuid
      t.references :product_option_value, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_index :variant_option_values, %i[variant_id product_option_value_id],
              unique: true,
              name: 'idx_vov_unique_variant_id_and_product_option_value_id'
  end
end
