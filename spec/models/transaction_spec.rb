# frozen_string_literal: true

# spec/models/transaction_spec.rb

require 'rails_helper'

RSpec.describe Transaction do
  let(:budget) { create(:budget) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:price_in_cents) }
    it { is_expected.to validate_presence_of(:due_at) }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:status).with_values(overdue: 1, created: 2, paid: 3) }
    it { is_expected.to define_enum_for(:kind).with_values(once: 1, fixed: 2, installment: 3) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:budget) }
  end
end
