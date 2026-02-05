# frozen_string_literal: true

class CreateGuestSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :guest_sessions, id: :uuid do |t|
      t.string :user_agent

      t.timestamps
    end
  end
end
