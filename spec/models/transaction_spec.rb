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

  describe 'callbacks' do
    let(:transaction) { create(:transaction, budget:) }

    it 'calls check_status before saving' do
      expect(transaction).to receive(:update_status)
      transaction.save
    end
  end

  describe 'methods' do
    let(:transaction) { create(:transaction, budget:) }

    it 'calculates price correctly' do
      transaction.price_in_cents = 2500
      expect(transaction.price).to eq(25.00)
    end

    it 'checks if the transaction is late' do
      transaction.due_at = 2.days.ago
      expect(transaction.late?).to be true

      transaction.due_at = 2.days.from_now
      expect(transaction.late?).to be false
    end
  end

  describe 'private methods' do
    let!(:transaction) { create(:transaction, budget:) }

    describe '#check_status' do
      context 'when due_at changes' do
        it 'updates status to overdue if late' do
          transaction.due_at = 2.days.ago
          transaction.save
          expect(transaction.reload.status).to eq('overdue')
        end

        it 'updates status to created if not late and not paid' do
          transaction.due_at = 2.days.from_now
          transaction.save
          expect(transaction.reload.status).to eq('created')
        end
      end

      context 'when due_at does not change' do
        it 'does not change the status' do
          expect { transaction.save }.not_to change { transaction.reload.status }
        end
      end
    end
  end
end
