# frozen_string_literal: true

FactoryBot.define do
  factory :guest_session
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
