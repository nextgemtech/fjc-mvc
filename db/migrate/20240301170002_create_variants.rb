# frozen_string_literal: true

class CreateVariants < ActiveRecord::Migration[7.0]
  def change
    create_table :variants, id: :uuid do |t|
      t.references :product, null: false, foreign_key: true, type: :uuid
      t.string :sku
      t.integer :position
      t.decimal :cost, precision: 10, scale: 2
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :count_on_hand, default: 0, null: false
      t.boolean :is_master, null: false, default: false
      t.boolean :trackable, null: false, default: true
      t.boolean :backorderable, null: false, default: false
      t.string :option_value_signature

      t.timestamps
    end

    add_index :variants, :position
    add_index :variants, :sku
    add_index :variants, %i[product_id option_value_signature], unique: true
  end
end
