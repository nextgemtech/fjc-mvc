# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Option, type: :model do
  let(:option) { build(:option) }

  it 'Create option' do
    expect(option).to be_valid
    expect(option.name).to be_present
  end
end

# == Schema Information
#
# Table name: options
#
#  id           :uuid             not null, primary key
#  display_name :string           not null
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
