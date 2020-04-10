# frozen_string_literal: true

require 'email_spectacular/version'
require 'email_spectacular/adaptors/action_mailer_adaptor'
require 'email_spectacular/extensions/action_mailer_extension'

# High-level email spec helpers for acceptance, feature and request tests.
#
# @author Aleck Greenham
#
# @see https://github.com/greena13/email_spectacular EmailSpectacular Github page
module EmailSpectacular
  class << self
    def helper_name=(method_name)
      EmailSpectacular::ActionMailerAdaptor.alias_method method_name, :email
      EmailSpectacular::ActionMailerAdaptor.remove_method :email
    end

    def mock_sending_enqueued_emails=(enabled)
      return unless enabled

      @_mocking_sending_enqueued_emails = true
      ActionMailer::MessageDelivery.include(EmailSpectacular::ActionMailerExtension)
    end

    attr_reader :_mocking_sending_enqueued_emails

    def configure
      if block_given?
        yield(EmailSpectacular)
      end
    end
  end
end
