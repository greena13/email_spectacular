# frozen_string_literal: true

require 'email_spectacular/dsl'
require 'email_spectacular/failure_descriptions'
require 'email_spectacular/matchers'

module EmailSpectacular
  class EmailFilter
    include DSL
    include Matchers
    include FailureDescriptions
  end
end
