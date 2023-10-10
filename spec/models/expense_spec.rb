# frozen_string_literal: true

# spec/models/expense_spec.rb

require 'rails_helper'

RSpec.describe Expense do
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

  describe 'callbacks' do
    let(:expense) { create(:expense, budget:) }

    it 'calls check_status before saving' do
      expect(expense).to receive(:update_status)
      expense.save
    end
  end

  describe 'methods' do
    let(:expense) { create(:expense, budget:) }

    it 'calculates price correctly' do
      expense.price_in_cents = 2500
      expect(expense.price).to eq(25.00)
    end

    it 'checks if the expense is late' do
      expense.due_at = 2.days.ago
      expect(expense.late?).to be true

      expense.due_at = 2.days.from_now
      expect(expense.late?).to be false
    end
  end

  describe 'private methods' do
    let!(:expense) { create(:expense, budget:) }

    describe '#check_status' do
      context 'when due_at changes' do
        it 'updates status to overdue if late' do
          expense.due_at = 2.days.ago
          expense.save
          expect(expense.reload.status).to eq('overdue')
        end

        it 'updates status to created if not late and not paid' do
          expense.due_at = 2.days.from_now
          expense.save
          expect(expense.reload.status).to eq('created')
        end
      end

      context 'when due_at does not change' do
        it 'does not change the status' do
          expect { expense.save }.not_to change { expense.reload.status }
        end
      end
    end
  end
end
