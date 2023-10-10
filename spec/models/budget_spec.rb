# frozen_string_literal: true

# spec/models/budget_spec.rb

require 'rails_helper'

RSpec.describe Budget do
  describe 'associations' do
    it { is_expected.to have_many(:expenses) }
    it { is_expected.to have_many(:budget_users) }
    it { is_expected.to have_many(:users).through(:budget_users) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
