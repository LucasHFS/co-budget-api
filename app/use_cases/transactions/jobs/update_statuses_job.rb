# frozen_string_literal: true

module Transactions
  module Jobs
    class UpdateStatusesJob
      include Sidekiq::Job

      def perform
        Transaction.update_statuses
      end
    end
  end
end
