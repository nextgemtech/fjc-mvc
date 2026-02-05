# frozen_string_literal: true

class Option < ApplicationRecord
  acts_as_list

  # Relations
  has_many :product_option, dependent: :destroy

  # Scopes
  scope :sort_by_position, -> { order(position: :asc) }

  # Validations
  validates :name, presence: true, uniqueness: true
end

# == Schema Information
#
# Table name: options
#
#  id           :uuid             not null, primary key
#  display_name :string
#  name         :string           not null
#  placeholder  :string
#  position     :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_options_on_name  (name) UNIQUE
#
