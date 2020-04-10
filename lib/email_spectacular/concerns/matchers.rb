# frozen_string_literal: true

require 'email_spectacular/adaptors/capybara_adaptor'

module EmailSpectacular
  # Module containing helper methods for matching expectations against emails
  #
  # @author Aleck Greenham
  module Matchers
    include CapybaraAdaptor

    MATCHERS = {
      to: :to,
      from: :from,
      with_subject: :subject,
      with_text: {
        match: ->(_, email, value) { value.all? { |text| email.has_text?(text) } },
        actual: ->(_, email) { email.text }
      },
      matching_selector: {
        match: ->(_, email, value) { value.all? { |selector| email.has_selector?(selector) } },
        actual: ->(_, email) { email.native },
        actual_name: :with_body
      },
      with_link: {
        match: ->(_, email, value) { value.all? { |url| email.has_selector?("a[href='#{url}']") } },
        actual: ->(_, email) { email.native },
        actual_name: :with_body
      },
      with_image: {
        match: ->(_, email, value) { value.all? { |url| email.has_selector?("img[src='#{url}']") } },
        actual: ->(_, email) { email.native },
        actual_name: :with_body
      }
    }.freeze

    def self.included(base) # rubocop:disable Metrics/MethodLength
      base.class_eval do
        def matching_emails(emails, scopes)
          emails.each_with_object(sent: [], enqueued: []) do |email, memo|
            matches_scopes = scopes.all? do |attribute, expected|
              email_matches?(email, MATCHERS[attribute], expected)
            end

            if matches_scopes
              if email.instance_variable_get(:@enqueued)
                memo[:enqueued] << email
              else
                memo[:sent] << email
              end
            end
          end
        end

        def email_matches?(email, assertion, expected)
          case assertion
          when :to
            !(expected & email.send(assertion)).empty?
          when String, Symbol
            email.send(assertion).include?(expected)
          when Hash
            assertion[:match].call(email, parsed_emails(email), expected)
          else
            raise "Unsupported assertion mapping '#{assertion}' of type #{assertion.class.name}"
          end
        end
      end
    end
  end
end
