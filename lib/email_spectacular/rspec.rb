# frozen_string_literal: true

require 'email_spectacular.rb'
require 'email_spectacular/rspec_matcher'
require 'email_spectacular/adaptors/action_mailer_adaptor'

module EmailSpectacular
  # Module containing email helper methods that can be mixed into the RSpec test scope
  #
  # @author Aleck Greenham
  module RSpec
    include ActionMailerAdaptor

    # Creates a new email expectation that allows asserting emails should have specific
    # attributes, applied only to send emails.
    #
    # @see EmailSpectacular::Expectation
    #
    # @example Asserting email has been sent
    #   expect(email).to have_been_sent.to('test@email.com')
    def have_been_sent # rubocop:disable Naming/PredicateName
      EmailSpectacular::RSpecMatcher.new(enqueued: false)
    end

    # Creates a new email expectation that allows asserting emails should have specific
    # attributes, applied only to emails that have been enqueued to be sent.
    #
    # @see EmailSpectacular::Expectation
    #
    # @example Asserting email has been enqueued
    #   expect(email).to have_been_enqueued.to('test@email.com')
    def have_been_enqueued # rubocop:disable Naming/PredicateName
      unless EmailSpectacular._mocking_sending_enqueued_emails
        raise 'EmailSpectacular: Cannot use the have_been_enqueued assertion without setting the ' \
              'mock_sending_enqueued_emails configuration option.'
      end

      EmailSpectacular::RSpecMatcher.new(enqueued: true)
    end
  end
end
