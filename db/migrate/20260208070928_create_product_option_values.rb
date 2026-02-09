# frozen_string_literal: true

class CreateProductOptionValues < ActiveRecord::Migration[7.2]
  def change
    create_table :product_option_values, id: :uuid do |t|
      t.references :product_option, null: false, foreign_key: true, type: :uuid
      t.string :name, null: false

      t.timestamps
    end

    add_index :product_option_values, %i[name product_option_id], unique: true
  end
end
