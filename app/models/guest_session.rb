# frozen_string_literal: true

class GuestSession < ApplicationRecord
  has_many :carts, dependent: :destroy
  has_many :orders, dependent: :nullify
  has_many :shipping_detail, as: :shippable, dependent: :destroy
end

# == Schema Information
#
# Table name: guest_sessions
#
#  id         :uuid             not null, primary key
#  user_agent :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
