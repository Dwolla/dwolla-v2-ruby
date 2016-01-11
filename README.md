# Dwolla

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/dwolla`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dwolla'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dwolla

## Usage

#### Creating a client

```ruby
$dwolla = Dwolla::Client.new(:id => "CLIENT_ID", :secret => "CLIENT_SECRET") do |optional_config|
  optional_config.environment = :sandbox
  optional_config.on_grant do |token|
    YourDwollaTokenData.create! token
  end
  optional_config.faraday do |faraday|
    faraday.response :logger
    faraday.adapter Faraday.default_adapter
  end
end
```

#### Authorization

Get an application token:

```ruby
$dwolla.auths.client :scope => "ManagerCustomers|Funding"
```

Get an account token:

```ruby
class YourDwollaAuthController < ApplicationController
  def authorize
    redirect_to auth.url
  end

  def callback
    token = auth.callback params
    session[:dwolla_account_id] = token.account_id
  end

  private

  def auth
    $dwolla.auths.new :redirect_uri => "https://yoursite.com/callback",
                      :scope => "ManagerCustomers|Funding"
  end
end
```

Refresh a token:

```ruby
token = $dwolla.auths.refresh expired_token
```

Initialize a token:

```ruby
token_data = YourDwollaTokenData.find_by :account_id => "ACCOUNT_ID"
token = $dwolla.tokens.new token_data
```

#### Making requests

```ruby
token.get "/resource", :foo => "bar"
token.post "/resource", :foo => "bar"
token.post "/resource", :foo => Faraday.UploadIO.new("/path/to/bar.png", "image/png")
token.put "/resource", :foo => "bar"
token.put "/resource", :foo => Faraday.UploadIO.new("/path/to/bar.png", "image/png")
token.delete "/resource"
```

In parallel:

```ruby
foo, bar = nil

token.in_parallel do
  foo = token.get "/foo" # => nil
  bar = token.get "/bar" # => nil
end

foo # => { ... }
bar # => { ... }
```

Accessing response headers:

```ruby
customer = token.post "/customers", customer_params
customer = token.get customer.headers[:location]
```

#### Errors

All errors inherit from `Dwolla::Error`

OAuth errors have `error`, `error_description`, and `error_uri` attributes.

Dwolla API errors have `code`, `message`, `_links`, and `_embedded` attributes.

**Error list:**

- `Dwolla::AccessDeniedError`
- `Dwolla::InvalidCredentialsError`
- `Dwolla::NotFoundError`
- `Dwolla::BadRequestError`
- `Dwolla::InvalidGrantError`
- `Dwolla::RequestTimeoutError`
- `Dwolla::ExpiredAccessTokenError`
- `Dwolla::InvalidRequestError`
- `Dwolla::ServerError`
- `Dwolla::ForbiddenError`
- `Dwolla::InvalidResourceStateError`
- `Dwolla::TemporarilyUnavailableError`
- `Dwolla::InvalidAccessTokenError`
- `Dwolla::InvalidScopeError`
- `Dwolla::UnauthorizedClientError`
- `Dwolla::InvalidAccount_statusError`
- `Dwolla::InvalidScopesError`
- `Dwolla::UnsupportedGrantTypeError`
- `Dwolla::InvalidApplicationStatusError`
- `Dwolla::InvalidVersionError`
- `Dwolla::UnsupportedResponseTypeError`
- `Dwolla::InvalidClientError`
- `Dwolla::MethodNotAllowedError`
- `Dwolla::ValidationError`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dwolla.

## License

The gem is available as open source under the terms of the [Unlicense License](http://unlicense.org/).
