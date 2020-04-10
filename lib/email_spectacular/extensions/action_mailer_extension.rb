# frozen_string_literal: true

module EmailSpectacular
  # Extensions to ActionMailer::MessageDelivery to mock the enqueuing of emails
  module ActionMailerExtension
    def self.included(base)
      base.class_eval do
        def deliver_later(options = {})
          message.instance_variable_set(:@enqueued, true)
          deliver_now
        end
      end
    end
  end
end
