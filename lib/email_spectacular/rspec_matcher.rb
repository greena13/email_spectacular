# frozen_string_literal: true

require 'email_spectacular/concerns/dsl'
require 'email_spectacular/concerns/failure_descriptions'
require 'email_spectacular/concerns/matchers'

module EmailSpectacular
  # Backing class for {#have_been_sent} declarative syntax for specifying email
  # expectations. Provides ability to assert emails have been sent in a given test
  # that match particular attribute values, such as sender, receiver or contents.
  #
  # Implements the RSpec Matcher interface
  #
  # @author Aleck Greenham
  #
  # @see EmailSpectacular::RSpec#email
  # @see EmailSpectacular::RSpec#have_been_sent
  class RSpecMatcher
    include DSL
    include Matchers
    include FailureDescriptions

    # Declares that RSpec should not attempt to diff the actual and expected values
    # to put in the failure message. This class takes care of diffing and presenting
    # the differences, itself.
    #
    # @return [false] Always returns false
    def diffable?
      false
    end

    # Whether at least one email was sent during the current test that matches the
    # constructed expectation
    #
    # @return [Boolean] True when a matching email was sent
    def matches?(emails)
      @emails = emails
      @matching_emails = matching_emails(emails, @scopes)
      (@enqueued ? @matching_emails[:enqueued] : @matching_emails[:sent]).any?
    end

    # Message to display to StdOut by RSpec if the equality check fails. Includes a
    # complete a human-readable summary of the differences between what emails were
    # expected to be sent, and what were actually sent (if any).
    #
    # This method is only used when the positive assertion is used, i.e.
    # <tt>expect(email).to have_been_sent<tt>.
    #
    # For the failure message used for negative assertions, i.e.
    # <tt>expect(email).to_not have_been_sent</tt>, see #failure_message_when_negated
    #
    # @see #failure_message_when_negated
    #
    # @return [String] message Full failure message with explanation of the differences
    #         between what emails were expected and what was actually sent
    def failure_message
      attribute, expected_value =
        attribute_and_expected_value(@scopes, @emails)

      describe_failed_assertion(attribute, expected_value)
    end

    # Failure message to display for negative RSpec assertions, i.e.
    # <tt>expect(email).to_not have_been_sent</tt>.
    #
    # For the failure message displayed for positive assertions, see #failure_message.
    #
    # @see #failure_message
    #
    # @return [String] message Full failure message with explanation of the differences
    #         between what emails were expected and what was actually sent
    def failure_message_when_negated
      field_descriptions = attribute_descriptions(@scopes.keys)
      value_descriptions = value_descriptions(@scopes.values)

      expectation_description(
        'Expected no emails to be sent',
        field_descriptions,
        value_descriptions
      )
    end
  end
end
