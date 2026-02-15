# frozen_string_literal: true

class CreateOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :options, id: :uuid do |t|
      t.string :name, null: false
      t.string :display_name, null: false
      t.string :placeholder
      t.integer :position

      t.timestamps
    end

    add_index :options, :name, unique: true
  end
end
