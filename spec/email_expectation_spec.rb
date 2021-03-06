# frozen_string_literal: true

require 'email_spectacular/rspec'

require_relative './support/email_mock'

RSpec.describe 'have_sent_email' do
  include EmailSpectacular::RSpec

  context 'when no emails have been sent' do
    subject { [] }

    it 'then the positive assertion fails' do
      expect do
        expect(subject).to have_been_sent
      end.to raise_error.with_message(
        'Expected an email to be sent. However, no emails were sent.'
      )
    end

    it 'then the negative assertion passes' do
      expect do
        expect(subject).to_not have_been_sent
      end.to_not raise_error
    end

    it "then a non-matching 'to' assertion fails" do
      expect do
        expect(subject).to have_been_sent.to('test@email.com')
      end.to raise_error.with_message(
        'Expected an email to be sent to \'test@email.com\'. However, no emails were sent.'
      )
    end

    it "then a non-matching 'from' assertion fails" do
      expect do
        expect(subject).to have_been_sent.from('test@email.com')
      end.to raise_error.with_message(
        'Expected an email to be sent from \'test@email.com\'. However, no emails were sent.'
      )
    end

    it "then a non-matching 'with_subject' assertion fails" do
      expect do
        expect(subject).to have_been_sent.with_subject('Subject')
      end.to raise_error.with_message(
        'Expected an email to be sent with subject \'Subject\'. However, no emails were sent.'
      )
    end

    it "then a non-matching 'with_text' assertion fails" do
      expect do
        expect(subject).to have_been_sent.with_text('Text')
      end.to raise_error.with_message(
        'Expected an email to be sent with text \'Text\'. However, no emails were sent.'
      )
    end

    it "then a non-matching 'matching_selector' assertion fails" do
      expect do
        expect(subject).to have_been_sent.matching_selector('h1')
      end.to raise_error.with_message(
        'Expected an email to be sent matching selector \'h1\'. However, no emails were sent.'
      )
    end

    it "then a non-matching 'with_link' assertion fails" do
      expect do
        expect(subject).to have_been_sent.with_link('www.example.com')
      end.to raise_error.with_message(
        'Expected an email to be sent with link \'www.example.com\'. However, no emails were sent.'
      )
    end

    it "then a non-matching 'with_image' assertion fails" do
      expect do
        expect(subject).to have_been_sent.with_image('www.example.com')
      end.to raise_error.with_message(
        'Expected an email to be sent with image \'www.example.com\'. However, no emails were sent.'
      )
    end
  end

  context 'when an email has been sent' do
    subject { [EmailMock.new] }

    it 'then the unqualified assertion passes' do
      expect do
        expect(subject).to have_been_sent
      end.to_not raise_error
    end

    it 'then the unqualified negative assertion fails' do
      expect do
        expect(subject).to_not have_been_sent
      end.to raise_error('Expected no emails to be sent.')
    end
  end

  context 'when a matching email has been sent' do
    subject { [EmailMock.new] }

    it "then a positive 'to' assertion passes" do
      expect do
        expect(subject).to have_been_sent.to(subject[0].to[0])
      end.to_not raise_error
    end

    it "then a negative 'to' assertion fails" do
      expect do
        expect(subject).to_not have_been_sent.to(subject[0].to[0])
      end.to raise_error.with_message(
        "Expected no emails to be sent to '#{subject[0].to[0]}'."
      )
    end

    it "then a positive 'from' assertion passes" do
      expect do
        expect(subject).to have_been_sent.from(subject[0].from[0])
      end.to_not raise_error
    end

    it "then a negative 'from' assertion fails" do
      expect do
        expect(subject).to_not have_been_sent.from(subject[0].from[0])
      end.to raise_error.with_message(
        "Expected no emails to be sent from '#{subject[0].from[0]}'."
      )
    end

    it "then a positive 'with_subject' assertion passes" do
      expect do
        expect(subject).to have_been_sent.with_subject(subject[0].subject)
      end.to_not raise_error
    end

    it "then a negative 'with_subject' assertion fails" do
      expect do
        expect(subject).to_not have_been_sent.with_subject(subject[0].subject)
      end.to raise_error.with_message(
        "Expected no emails to be sent with subject '#{subject[0].subject}'."
      )
    end

    it "then a positive 'with_text' assertion passes" do
      expect do
        expect(subject).to have_been_sent.with_text(subject[0].text)
      end.to_not raise_error
    end

    it "then a negative 'with_text' assertion fails" do
      expect do
        expect(subject).to_not have_been_sent.with_text(subject[0].text)
      end.to raise_error.with_message(
        "Expected no emails to be sent with text '#{subject[0].text}'."
      )
    end

    it "then a positive 'matching_selector' assertion passes" do
      expect do
        expect(subject).to have_been_sent.matching_selector('h1')
      end.to_not raise_error
    end

    it "then a negative 'matching_selector' assertion fails" do
      expect do
        expect(subject).to_not have_been_sent.matching_selector('h1')
      end.to raise_error.with_message(
        "Expected no emails to be sent matching selector 'h1'."
      )
    end

    it "then a positive 'with_link' assertion passes" do
      expect do
        expect(subject).to have_been_sent.with_link('www.test.com')
      end.to_not raise_error
    end

    it "then a negative 'with_link' assertion fails" do
      expect do
        expect(subject).to_not have_been_sent.with_link('www.test.com')
      end.to raise_error.with_message(
        "Expected no emails to be sent with link 'www.test.com'."
      )
    end

    it "then a positive 'with_image' assertion passes" do
      expect do
        expect(subject).to have_been_sent.with_image('www.test.com')
      end.to_not raise_error
    end

    it "then a negative 'with_image' assertion fails" do
      expect do
        expect(subject).to_not have_been_sent.with_image('www.test.com')
      end.to raise_error.with_message(
        "Expected no emails to be sent with image 'www.test.com'."
      )
    end
  end

  context 'when a non-matching email has been sent' do
    subject { [EmailMock.new] }

    it "then a positive 'to' assertion fails" do
      expect do
        expect(subject).to have_been_sent.to('other@email.com')
      end.to raise_error.with_message(
        "Expected an email to be sent to 'other@email.com'. However, 1 was sent to '#{subject[0].to[0]}'."
      )
    end

    it "then a negative 'to' assertion passes" do
      expect do
        expect(subject).to_not have_been_sent.to('other@email.com')
      end.to_not raise_error
    end

    it "then a positive 'from' assertion fails" do
      expect do
        expect(subject).to have_been_sent.from('other@email.com')
      end.to raise_error.with_message(
        "Expected an email to be sent from 'other@email.com'. However, 1 was sent from '#{subject[0].from[0]}'."
      )
    end

    it "then a negative 'from' assertion passes" do
      expect do
        expect(subject).to_not have_been_sent.from('other@email.com')
      end.to_not raise_error
    end

    it "then a positive 'with_subject' assertion fails" do
      expect do
        expect(subject).to have_been_sent.with_subject('Other Subject')
      end.to raise_error.with_message(
        "Expected an email to be sent with subject 'Other Subject'. However, 1 was " \
        "sent with subject '#{subject[0].subject}'."
      )
    end

    it "then a negative 'with_subject' assertion passes" do
      expect do
        expect(subject).to_not have_been_sent.with_subject('Other Subject')
      end.to_not raise_error
    end

    it "then a positive 'with_text' assertion fails" do
      expect do
        expect(subject).to have_been_sent.with_text('Other text')
      end.to raise_error.with_message(
        <<~MSG.chomp
          Expected an email to be sent with text 'Other text'. However, 1 was sent with text 
          
          (Content Type text/html):
          
          #{subject[0].text}.
        MSG
      )
    end

    it "then a negative 'with_text' assertion passes" do
      expect do
        expect(subject).to_not have_been_sent.with_text('Other text')
      end.to_not raise_error
    end

    it "then a positive 'matching_selector' assertion fails" do
      expect do
        expect(subject).to have_been_sent.matching_selector('.other')
      end.to raise_error.with_message(
        <<~MSG.chomp
          Expected an email to be sent matching selector '.other'. However, 1 was sent with body 

          (Content Type text/html):

          #{subject[0].body}.
        MSG
      )
    end

    it "then a negative 'matching_selector' assertion passes" do
      expect do
        expect(subject).to_not have_been_sent.matching_selector('.other')
      end.to_not raise_error
    end

    it "then a positive 'with_link' assertion fails" do
      expect do
        expect(subject).to have_been_sent.with_link('www.other.com')
      end.to raise_error.with_message(
        <<~MSG.chomp
          Expected an email to be sent with link 'www.other.com'. However, 1 was sent with body 

          (Content Type text/html):

          #{subject[0].body}.
        MSG
      )
    end

    it "then a negative 'with_link' assertion passes" do
      expect do
        expect(subject).to_not have_been_sent.with_link('www.other.com')
      end.to_not raise_error
    end

    it "then a positive 'with_image' assertion fails" do
      expect do
        expect(subject).to have_been_sent.with_image('www.other.com')
      end.to raise_error.with_message(
        <<~MSG.chomp
          Expected an email to be sent with image 'www.other.com'. However, 1 was sent with body 

          (Content Type text/html):

          #{subject[0].body}.
        MSG
      )
    end

    it "then a negative 'with_image' assertion passes" do
      expect do
        expect(subject).to_not have_been_sent.with_image('www.other.com')
      end.to_not raise_error
    end
  end

  context 'when multiple emails have been sent' do
    subject { [EmailMock.new, EmailMock.new(to: 'other@email.com')] }

    it 'then a positive assertion matching the first email passes' do
      expect do
        expect(subject).to have_been_sent.to(subject[0].to[0])
      end.to_not raise_error
    end

    it 'then a negative assertion matching the first email fails' do
      expect do
        expect(subject).to_not have_been_sent.to(subject[0].to[0])
      end.to raise_error.with_message(
        "Expected no emails to be sent to '#{subject[0].to[0]}'."
      )
    end

    it 'then a positive assertion matching the second email passes' do
      expect do
        expect(subject).to have_been_sent.to(subject[1].to)
      end.to_not raise_error
    end

    it 'then a negative assertion matching the second email fails' do
      expect do
        expect(subject).to_not have_been_sent.to(subject[1].to)
      end.to raise_error.with_message(
        "Expected no emails to be sent to '#{subject[1].to[0]}'."
      )
    end
  end

  context 'when using multiple qualifiers' do
    subject { [EmailMock.new] }

    it 'then a positive assertions correctly matches a matching email' do
      expect do
        expect(subject).to have_been_sent.to(subject[0].to[0]).from(subject[0].from[0])
      end.to_not raise_error
    end

    it "then a positive assertions don't match an email if the first qualifier isn't satisfied" do
      expect do
        expect(subject).to have_been_sent.to('other@email.com').from(subject[0].from[0])
      end.to raise_error.with_message(
        "Expected an email to be sent to 'other@email.com'. However, 1 was sent to '#{subject[0].to[0]}'."
      )
    end

    it "then a positive assertions don't match an email if the last qualifier isn't satisfied" do
      expect do
        expect(subject).to have_been_sent.to(subject[0].to[0]).from('other@email.com')
      end.to raise_error.with_message(
        "Expected an email to be sent from 'other@email.com'. However, 1 was sent from '#{subject[0].from[0]}'."
      )
    end

    it 'then a negative assertions correctly matches a matching email' do
      expect do
        expect(subject).to_not have_been_sent.to(subject[0].to[0]).from(subject[0].from[0])
      end.to raise_error.with_message(
        "Expected no emails to be sent to '#{subject[0].to[0]}' from '#{subject[0].from[0]}'."
      )
    end

    it "then a negative assertions don't match an email if the first qualifier isn't satisfied" do
      expect do
        expect(subject).to_not have_been_sent.to('other@email.com').from(subject[0].from[0])
      end.to_not raise_error
    end

    it "then a negative assertions don't match an email if the last qualifier isn't satisfied" do
      expect do
        expect(subject).to_not have_been_sent.to(subject[0].to[0]).from('other@email.com')
      end.to_not raise_error
    end
  end

  context 'when using the and method' do
    subject { [EmailMock.new] }

    it 'then a positive assertion will fail if the first qualifier is not satisfied' do
      expect do
        expect(subject).to have_been_sent.with_text('Other').and('Email')
      end.to raise_error.with_message(
        <<~MSG.chomp
          Expected an email to be sent with text 'Other' and 'Email'. However, 1 was sent with text 

          (Content Type text/html):

          #{subject[0].text}.
        MSG
      )
    end

    it 'then a positive assertion will fail if the second qualifier is not satisfied' do
      expect do
        expect(subject).to have_been_sent.with_text('Test').and('Other')
      end.to raise_error.with_message(
        <<~MSG.chomp
          Expected an email to be sent with text 'Test' and 'Other'. However, 1 was sent with text 

          (Content Type text/html):

          #{subject[0].text}.
        MSG
      )
    end

    it 'then a positive assertion will pass if both qualifiers are satisfied' do
      expect do
        expect(subject).to have_been_sent.with_text('Test').and('Email')
      end.to_not raise_error
    end

    it 'then a negative assertion will pass if the first qualifier is not satisfied' do
      expect do
        expect(subject).to_not have_been_sent.with_text('Other').and('Email')
      end.to_not raise_error
    end

    it 'then a negative assertion will pass if the second qualifier is not satisfied' do
      expect do
        expect(subject).to_not have_been_sent.with_text('Test').and('Other')
      end.to_not raise_error
    end

    it 'then a negative assertion will fail if both qualifiers are satisfied' do
      expect do
        expect(subject).to_not have_been_sent.with_text('Test').and('Email')
      end.to raise_error.with_message(
        'Expected no emails to be sent with text \'Test\' and \'Email\'.'
      )
    end
  end
end
