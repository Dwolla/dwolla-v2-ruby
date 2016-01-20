# DwollaV2

![Build Status](https://travis-ci.org/Dwolla/dwolla-v2-ruby.svg)

Dwolla V2 Ruby client. For the V1 Ruby client see [Dwolla/dwolla-ruby](https://github.com/Dwolla/dwolla-ruby).

[API Documentation](https://docsv2.dwolla.com)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dwolla_v2', '~> 0.1'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dwolla_v2

## Usage

#### Creating a client

```ruby
$dwolla = DwollaV2::Client.new(id: "CLIENT_ID", secret: "CLIENT_SECRET") do |optional_config|
  optional_config.environment = :sandbox
  optional_config.on_grant do |token|
    YourTokenData.create! token
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
$dwolla.auths.client scope: "ManagerCustomers|Funding"
```

Get an account token:

```ruby
class YourAuthController < ApplicationController
  def authorize
    redirect_to auth.url
  end

  def callback
    token = auth.callback params
    session[:account_id] = token.account_id
  end

  private

  def auth
    $dwolla.auths.new redirect_uri: "https://yoursite.com/callback",
                      scope: "ManagerCustomers|Funding"
  end
end
```

Refresh a token:

```ruby
token = $dwolla.auths.refresh expired_token
```

Initialize a token:

```ruby
token_data = YourTokenData.find_by account_id: "ACCOUNT_ID"
token = $dwolla.tokens.new token_data
```

#### Making requests

```ruby
token.get "/resource", foo: "bar"
token.post "/resource", foo: "bar"
token.post "/resource", foo: Faraday.UploadIO.new("/path/to/bar.png", "image/png")
token.put "/resource", foo: "bar"
token.put "/resource", foo: Faraday.UploadIO.new("/path/to/bar.png", "image/png")
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

All errors inherit from `DwollaV2::Error`

OAuth errors have `error`, `error_description`, and `error_uri` attributes.

Dwolla API errors have `code`, `message`, `_links`, and `_embedded` attributes.

**Error list:**

- `DwollaV2::AccessDeniedError`
- `DwollaV2::InvalidCredentialsError`
- `DwollaV2::NotFoundError`
- `DwollaV2::BadRequestError`
- `DwollaV2::InvalidGrantError`
- `DwollaV2::RequestTimeoutError`
- `DwollaV2::ExpiredAccessTokenError`
- `DwollaV2::InvalidRequestError`
- `DwollaV2::ServerError`
- `DwollaV2::ForbiddenError`
- `DwollaV2::InvalidResourceStateError`
- `DwollaV2::TemporarilyUnavailableError`
- `DwollaV2::InvalidAccessTokenError`
- `DwollaV2::InvalidScopeError`
- `DwollaV2::UnauthorizedClientError`
- `DwollaV2::InvalidAccount_statusError`
- `DwollaV2::InvalidScopesError`
- `DwollaV2::UnsupportedGrantTypeError`
- `DwollaV2::InvalidApplicationStatusError`
- `DwollaV2::InvalidVersionError`
- `DwollaV2::UnsupportedResponseTypeError`
- `DwollaV2::InvalidClientError`
- `DwollaV2::MethodNotAllowedError`
- `DwollaV2::ValidationError`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Dwolla/dwolla-v2-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://github.com/Dwolla/dwolla-v2-ruby).

## Changelog

- **0.1.1** - Handle 500 errors with HTML response bodies when requesting tokens
