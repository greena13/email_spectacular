# frozen_string_literal: true

require 'email_spectacular/version'
require 'email_spectacular/adaptors/action_mailer_adaptor'

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

    def configure
      if block_given?
        yield(EmailSpectacular)
      end
    end
  end
end
