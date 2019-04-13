# frozen_string_literal: true

require 'email_spectacular/concerns/dsl'
require 'email_spectacular/concerns/failure_descriptions'
require 'email_spectacular/concerns/matchers'

module EmailSpectacular
  class EmailFilter
    include DSL
    include Matchers
    include FailureDescriptions
  end
end
