# spec/models/budget_spec.rb

require 'rails_helper'

RSpec.describe Budget, type: :model do
  describe 'associations' do
    it { should have_many(:expenses) }
    it { should have_many(:budget_users) }
    it { should have_many(:users).through(:budget_users) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'methods' do
    let(:budget) { create(:budget) }
    let(:expense1) { create(:expense, budget: budget, price_in_cents: 5000) }
    let(:expense2) { create(:expense, status: :paid, budget: budget, price_in_cents: 3000) }

    before do
      budget
      expense1
      expense2
    end

    it 'calculates total payable correctly' do
      expect(budget.total_payable).to eq(80.00)
    end

    it 'calculates balance to pay correctly' do
      expect(budget.balance_to_pay).to eq(50.00)
    end

    it 'updates balance prices correctly' do
      expense1.paid!
      budget.reload

      expect(budget.total_payable).to eq(80.00)
      expect(budget.balance_to_pay).to eq(0)
    end
  end
end
