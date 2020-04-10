<p align="center">
  <img src="https://svgshare.com/i/CSb.svg" width="200px"><br/>
  <h2 align="center">EmailSpectacular</h2>
</p>

[![Gem](https://img.shields.io/gem/dt/email_spectacular.svg)]()
[![Build Status](https://travis-ci.org/greena13/email_spectacular.svg)](https://travis-ci.org/greena13/email_spectacular)
[![GitHub license](https://img.shields.io/github/license/greena13/email_spectacular.svg)](https://github.com/greena13/email_spectacular/blob/master/LICENSE)

High-level email spec helpers for acceptance, feature and request tests.

## Basic Usage

```ruby
it 'does many things, including sending an email' do
  # ...

  expect(email).to have_been_sent.to('user@email.com')
end
```

## What EmailSpectacular is

Expressive email assertions that let you succinctly describe when emails should and should not be sent.

### What EmailSpectacular is NOT

A library for low-level or unit-testing of ActionMailers.

## Installation

Add this line to your application's Gemfile:

```ruby
group :test do
  gem 'email_spectacular', require: false
end
```

Add `email_spectacular` to your `spec/rails_helper.rb`

```ruby
require 'email_spectacular/rspec'

RSpec.configure do |config|
  # ...

  email_spectacular_spec_types = %i[acceptance feature request]

  email_spectacular_spec_types.each do |spec_type|
    config.after(:each, type: spec_type) do
      # Clear emails between specs
      clear_emails
    end
    
    # Include email spectacular syntax in rspec tests
    config.include EmailSpectacular::RSpec, type: spec_type
  end
end
```

And then execute:

```bash
bundle install
```   

### Configuration

Email Spectacular is configured using the `configure` method. It's suggested you place this in your `spec/rails_helper.rb` file, after you require `email_specatular`:


```ruby
require 'email_spectacular/rspec'

EmailSpectacular.configure do |config|
  # Configuration here
end
```                   

#### Setting the name of the email helper

By default, Email Spectacular makes a `email` helper available for your expectation syntax (all examples below assume this default helper), however if this conflicts with anything in your test suite or is not preferred, you can specify a different helper name:

```ruby
EmailSpectacular.configure do |config|
  config.helper_name = :an_email # Default is 'email' 
end
``` 

#### Working with enqueued emails

If your emails are not sent immediately in your application - using `deliver_later` - you must mock this method in test mode so they appear to have sent to Email Spectacular, which is enabled using the `mock_sending_enqueued_emails` option:

```ruby
EmailSpectacular.configure do |config|
  # Mocks the enqueueing of emails so they appear in the list of sent email
  config.mock_sending_enqueued_emails = true
end
```       

This then enables the assertion `have_been_enqueued`, which has the same arguments and behaviour as `have_been_sent`, but will verify the email has been enqueued rather than sent immediately:

```ruby
expect(email).to have_been_enqueued.to('user@email.com')
```

## Usage

### Email receiver address

It's possible to assert an email was sent to one or more or more addresses using the following format:

```ruby
expect(email).to have_been_sent.to('user@email.com')
```

### Email sender address

Similarly, you can assert an email was sent from an address:

```ruby
expect(email).to have_been_sent.from('user@email.com')
```

### Email subject

You can assert an email's subject:

```ruby
expect(email).to have_been_sent.with_subject('Welcome!')
```

### Email body

You can assert the body of an email by text:

```ruby
expect(email).to have_been_sent.with_text('Welcome, user@email.com')
```

Or using a selector on the email's HTML:

```ruby
expect(email).to have_been_sent.with_selector('#password')
```

Or look for links:

```ruby
expect(email).to have_been_sent.with_link('www.site.com/onboarding/1')
```

Or images:

```ruby
expect(email).to have_been_sent.with_image('www.site.com/assets/images/welcome.png')
```

### Chaining assertions

You can chain any combination of the above that you want for ultra specific assertions:


```ruby
expect(email).to have_been_sent
                  .to('user@email.com')
                  .from('admin@site.com')
                  .with_subject('Welcome!')
                  .with_text('Welcome, user@email.com')
                  .with_selector('#password').and('#username')
                  .with_link('www.site.com/onboarding/1')
                  .with_image('www.site.com/assets/images/welcome.png')

```

You can also chain multiple assertions of the the same type with the `and` method:

```ruby
expect(email).to have_been_sent
                    .with_text('Welcome, user@email.com').and('Thanks for signing up')
```

### Asserting emails are NOT sent

The `have_sent_email` assertion works with the negative case as well:

```ruby
expect(email).to_not have_been_sent.with_text('Secret token')
```

### Clearing emails

Emails can be cleared at any point by calling `clear_emails` in your tests. This is helpful when you are testing a user workflow that may trigger multiple emails.

If you followed in installation steps above, emails will automatically be cleared between each spec.

## Gotchas and Troubleshooting

EmailSpectacular expects your application to configure `ActionMailer` to store emails in the `ActionMailer::Base.deliveries` array.

In a Rails app, this is done (automatically, by default) in your environment file: `config/environment/test.rb` 

```ruby
config.action_mailer.delivery_method = :test
```

## Test suite

`email_spectacular` comes with close-to-complete test coverage. You can run the test suite as follows:

```bash
rspec
```

## Contributing

1. Fork it ( https://github.com/greena13/email_spectacular/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Inspirations

* [CapybaraEmail](https://github.com/DockYard/capybara-email)
