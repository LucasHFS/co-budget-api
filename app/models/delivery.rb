# frozen_string_literal: true

class Delivery < ApplicationRecord
  belongs_to :order
  belongs_to :driver, class_name: 'User', foreign_key: 'user_id', optional: true, inverse_of: :deliveries
  belongs_to :sale_event

  validates :state, presence: true

  state_machine initial: :pending do
    state :pending
    state :prepared
    state :sent
    state :completed
    state :canceled

    event :register do
      transition any => :pending
    end

    event :start do
      transition any => :in_progress
    end

    event :complete do
      transition any => :completed
    end

    event :cancel do
      transition any => :canceled
    end

    before_transition to: :completed do |delivery|
      delivery.delivered_at = Time.current
    end
  end
end
