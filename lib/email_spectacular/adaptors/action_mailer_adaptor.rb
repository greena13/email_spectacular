# frozen_string_literal: true

module EmailSpectacular
  module ActionMailerAdaptor
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
  end
end
