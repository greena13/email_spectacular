# frozen_string_literal: true

require 'email_spectacular/rspec_matcher'

module EmailSpectacular
  # Module containing email helper methods that can be mixed into the RSpec test scope
  #
  # @author Aleck Greenham
  module RSpec
    # Syntactic sugar for referencing the list of emails sent since the start of the
    # test
    #
    # @example Asserting email has been sent
    #   expect(email).to have_been_sent.to('test@email.com')
    #
    # @return [Array<Mail::Message>] List of sent emails
    def email
      ActionMailer::Base.deliveries
    end

    # Clears the list of sent emails.
    #
    # @return void
    def clear_emails
      ActionMailer::Base.deliveries = []
    end

    # Creates a new email expectation that allows asserting emails should have specific
    # attributes.
    #
    # @see EmailSpectacular::Expectation
    #
    # @example Asserting email has been sent
    #   expect(email).to have_been_sent.to('test@email.com')
    def have_been_sent # rubocop:disable Naming/PredicateName
      EmailSpectacular::RSpecMatcher.new
    end
  end
end
