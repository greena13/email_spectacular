# frozen_string_literal: true

require 'capybara'

module EmailSpectacular
  # Module for parsing email bodies
  #
  # @author Aleck Greenham
  module CapybaraAdaptor
    def parsed_email_parts(email)
      email_parts_as_hash(email) do |email_part|
        parse(email_part)
      end
    end

    def raw_email_parts(email)
      email_parts_as_hash(email)
    end

    private

    def email_parts_as_hash(email)
      if email.parts.any?
        email.parts.each_with_object({}) do |email_part, memo|
          decoded = email_part.body.decoded
          memo[content_type_key(email_part)] = block_given? ? yield(decoded) : decoded
        end
      else
        encoded = email.body.encoded
        { content_type_key(email) => block_given? ? yield(encoded) : encoded }
      end
    end

    def parse(target)
      Capybara::Node::Simple.new(target)
    end

    def content_type_key(target)
      target.content_type.split(';').first
    end
  end
end
