# frozen_string_literal: true

require 'email_spectacular/adaptors/capybara_adaptor'
require 'email_spectacular/concerns/matchers'

module EmailSpectacular
  # Module containing the helper methods to describe the difference between the expected
  # and actual emails sent.
  #
  # @author Aleck Greenham
  module FailureDescriptions # rubocop:disable Metrics/ModuleLength
    include CapybaraAdaptor

    def self.included(base) # rubocop:disable Metrics/MethodLength
      base.class_eval do
        protected

        def attribute_and_expected_value(scopes, emails)
          scopes.each do |attribute, expected|
            matching_emails =
              emails.select do |email|
                email_matches?(email, EmailSpectacular::Matchers::MATCHERS[attribute], expected) &&
                  (!EmailSpectacular._mocking_sending_enqueued_emails ||
                    email.instance_variable_get(:@enqueued) == @enqueued)
              end

            return [attribute, expected] if matching_emails.empty?
          end

          [nil, nil]
        end

        def describe_failed_assertion(attribute_name, attribute_value)
          action = mail_action_description

          field_descriptions = attribute_descriptions([attribute_name])
          value_descriptions = value_descriptions([attribute_value])

          base_clause = expectation_description(
            "Expected an email to be #{action}",
            field_descriptions,
            value_descriptions
          )

          if @emails.empty?
            "#{base_clause} However, no emails were #{action}."
          elsif @matching_emails[:sent].any? || @matching_emails[:enqueued].any?
            opposite_action = @enqueued ? 'sent' : 'enqueued'
            "#{base_clause} However, it was #{opposite_action} instead."
          else
            field_descriptions = attribute_descriptions([attribute_name])

            email_values = sent_email_values(@emails, attribute_name)

            if email_values.any?
              base_clause + " However, #{email_pluralisation(@emails)} #{action} " \
              "#{result_description(field_descriptions, [to_sentence(email_values)])}."
            else
              base_clause
            end
          end
        end

        def attribute_descriptions(attributes)
          attributes.map do |attr|
            attr.to_s.tr('_', ' ')
          end
        end

        def value_descriptions(values)
          values.map do |value|
            case value
            when String
              "'#{value}'"
            when Array
              to_sentence(value.map { |val| "'#{val}'" })
            else
              value
            end
          end
        end

        def expectation_description(base_clause, field_descriptions, value_descriptions)
          description = base_clause

          additional_clauses = []

          field_descriptions.each.with_index do |field_description, index|
            clause = ''
            clause += " #{field_description}" unless field_description.empty?

            if (value_description = value_descriptions[index])
              clause += " #{value_description}"
            end

            additional_clauses.push(clause) unless clause.empty?
          end

          description + additional_clauses.join('') + '.'
        end

        private

        def mail_action_description
          if EmailSpectacular._mocking_sending_enqueued_emails
            @enqueued ? 'enqueued' : 'sent'
          else
            'sent'
          end
        end

        def result_description(field_descriptions, values)
          to_sentence(
            field_descriptions.map.with_index do |field_description, index|
              value = values[index]

              if ['matching selector', 'with link', 'with image'].include?(field_description)
                "with body #{value}"
              else
                "#{field_description} #{value}"
              end
            end
          )
        end

        def sent_email_values(emails, attribute)
          emails.each_with_object([]) do |email, memo|
            if %i[matching_selector with_link with_image].include?(attribute)
              memo << raw_email_parts(email).inject([]) do |description, (content_type, raw_email_part)|
                  description.push(
                    "\n\n(Content Type #{content_type}):\n\n#{raw_email_part}"
                  )
                end.join('')
            else
              matcher = EmailSpectacular::Matchers::MATCHERS[attribute]

              value =
                case matcher
                when String, Symbol
                  email.send(matcher)
                when Hash
                  parsed_email_parts(email).inject([]) do |description, (content_type, parsed_email_part)|
                    description.push(
                      "\n\n(Content Type #{content_type}):\n\n#{matcher[:actual].call(email, parsed_email_part)}"
                    )
                  end.join('')
                else
                  raise ArgumentError, "Failure related to an unknown or unsupported email attribute #{attribute}"
                end

              unless attribute == :with_text
                value = value.is_a?(String) ? "'#{value}'" : value.map { |element| "'#{element}'" }
              end

              memo << value
            end
          end
        end

        def email_pluralisation(emails)
          emails.length > 2 ? "#{emails.length} were" : '1 was'
        end

        def to_sentence(items)
          _items = items.flatten

          case _items.length
          when 0, 1
            _items.join('')
          when 2
            _items.join(' and ')
          else
            _items[0..(_items.length - 3)].join(', ') + ', ' + _items[(_items.length - 2).._items.length - 1].join(' and ')
          end
        end
      end
    end
  end
end
