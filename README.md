# DwollaV2

![Build Status](https://travis-ci.org/Dwolla/dwolla-v2-ruby.svg)

Dwolla V2 Ruby client. For the V1 Ruby client see [Dwolla/dwolla-ruby](https://github.com/Dwolla/dwolla-ruby).

[API Documentation](https://docsv2.dwolla.com)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dwolla_v2', '~> 1.2'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dwolla_v2

## `DwollaV2::Client`

### Basic usage

Create a client using your application's consumer key and secret found on the applications page
([Sandbox][apsandbox], [Production][approd]).

[apsandbox]: https://sandbox.dwolla.com/applications
[approd]: https://www.dwolla.com/applications

```ruby
# config/initializers/dwolla.rb
$dwolla = DwollaV2::Client.new(key: ENV["DWOLLA_APP_KEY"], secret: ENV["DWOLLA_APP_SECRET"])
```

### Using the sandbox environment (optional)

```ruby
# config/initializers/dwolla.rb
$dwolla = DwollaV2::Client.new(key: ENV["DWOLLA_APP_KEY"], secret: ENV["DWOLLA_APP_SECRET"]) do |config|
  config.environment = :sandbox
end
```

`environment=` defaults to `:production` and accepts either a String or a Symbol.

### Configure an `on_grant` callback (optional)

An `on_grant` callback is useful for storing new tokens when they are granted. For example, you
may have a `YourTokenData` ActiveRecord model that you use to store your tokens. The `on_grant`
callback is called with the `DwollaV2::Token` that was just granted by the server. You can pass
this to the `create!` method of an ActiveRecord model to create a record using the token's data.

```ruby
# config/initializers/dwolla.rb
$dwolla = DwollaV2::Client.new(key: ENV["DWOLLA_APP_KEY"], secret: ENV["DWOLLA_APP_SECRET"]) do |config|
  config.on_grant {|t| YourTokenData.create!(t) }
end
```

It is highly recommended that you encrypt any token data you store using
[attr_encrypted][attr_encrypted] or [vault-rails][vault-rails] (if you use [Vault][vault]). These
are both configured in your ActiveRecord models.

[attr_encrypted]: https://github.com/attr-encrypted/attr_encrypted
[vault-rails]: https://github.com/hashicorp/vault-rails
[vault]: https://www.vaultproject.io/

### Configure Faraday (optional)

DwollaV2 uses [Faraday][faraday] to make HTTP requests. You can configure your own
[Faraday middleware][faraday-middleware] and adapter when configuring your client. Remember to
always include an adapter last, even if you want to use the default adapter.

[faraday]: https://github.com/lostisland/faraday
[faraday-middleware]: https://github.com/lostisland/faraday_middleware

```ruby
# config/initializers/dwolla.rb
$dwolla = DwollaV2::Client.new(key: ENV["DWOLLA_APP_KEY"], secret: ENV["DWOLLA_APP_SECRET"]) do |config|
  config.faraday do |faraday|
    faraday.response :logger
    faraday.adapter Faraday.default_adapter
  end
end
```

## `DwollaV2::Token`

Tokens can be used to make requests to the Dwolla V2 API. There are two types of tokens:

### Application tokens

Application tokens are used to access the API on behalf of a consumer application. API resources that
belong to an application include: `webhook-subscriptions`, `events`, and `webhooks`. Application
tokens can be created using the [`client_credentials`][client_credentials] OAuth grant type:

**Note:** If an application has the `ManageCustomers` scope enabled, it can also be used to access
the API for White Label Customer related endpoints. Keep in mind, the application must belong to
same Dwolla account that will be used when creating and managing White Label Customers in the API.

[client_credentials]: https://tools.ietf.org/html/rfc6749#section-4.4

```ruby
application_token = $dwolla.auths.client
# => #<DwollaV2::Token client=#<DwollaV2::Client key="..." secret="..." environment=:sandbox> access_token="..." expires_in=3600 scope="...">
```

*Application tokens do not include a `refresh_token`. When an application token expires, generate
a new one using `$dwolla.auths.client`.*

### Account tokens

Account tokens are used to access the API on behalf of a Dwolla account. API resources that belong
to an account include `customers`, `funding-sources`, `documents`, `mass-payments`, `mass-payment-items`,
`transfers`, and `on-demand-authorizations`.

There are two ways to get an account token. One is by generating a token at
https://sandbox.dwolla.com/applications (Sandbox) or https://www.dwolla.com/applications (Production).

You can instantiate a generated token by doing the following:

```ruby
account_token = $dwolla.tokens.new access_token: "...", refresh_token: "..."
# => #<DwollaV2::Token client=#<DwollaV2::Client key="..." secret="..." environment=:sandbox> access_token="..." refresh_token="...">
```

The other way to get an account token is using the [`authorization_code`][authorization_code]
OAuth grant type. This flow works by redirecting a user to dwolla.com in order to get authorization
and sending them back to your website with an authorization code which can be exchanged for a token.
For example:

[authorization_code]: https://tools.ietf.org/html/rfc6749#section-4.1

```ruby
class YourAuthController < ApplicationController
  # redirect the user to dwolla.com for authorization
  def authorize
    redirect_to auth.url
  end

  # https://yoursite.com/callback?code=...&state=...
  def callback
    # exchange the code for a token
    token = auth.callback(params)
    # => #<DwollaV2::Token client=#<DwollaV2::Client key="..." secret="..." environment=:sandbox> access_token="..." refresh_token="..." expires_in=3600 scope="ManageCustomers|Funding" account_id="...">
    session[:account_id] = token.account_id
  end

  private

  def auth
    $dwolla.auths.new redirect_uri: "https://yoursite.com/callback",
                      scope: "ManageCustomers|Funding",
                      state: session[:state] ||= SecureRandom.hex(8), # optional
                      verified_account: true, # optional
                      dwolla_landing: "register" # optional
  end
end
```

### Refreshing tokens

Tokens with `refresh_token`s can be refreshed using `$dwolla.auths.refresh`, which takes a
`DwollaV2::Token` as its first argument and returns a new token.

```ruby
refreshed_token = $dwolla.auths.refresh(expired_token)
# => #<DwollaV2::Token client=#<DwollaV2::Client key="..." secret="..." environment=:sandbox> access_token="..." refresh_token="..." expires_in=3600 scope="ManageCustomers|Funding" account_id="...">
```

### Initializing pre-existing tokens:

`DwollaV2::Token`s can be initialized with the following attributes:

```ruby
$dwolla.tokens.new access_token: "...",
                   refresh_token: "...",
                   expires_in: 123,
                   scope: "...",
                   account_id: "..."
#<DwollaV2::Token client=#<DwollaV2::Client key="..." secret="..." environment=:sandbox> access_token="..." refresh_token="..." expires_in=123 scope="..." account_id="...">
```

```ruby
token_data = YourTokenData.first
$dwolla.tokens.new(token_data)
```

## Requests

`DwollaV2::Token`s can make requests using the `#get`, `#post`, `#put`, and `#delete` methods.

```ruby
# GET api.dwolla.com/resource?foo=bar
token.get "resource", foo: "bar"

# POST api.dwolla.com/resource {"foo":"bar"}
token.post "resource", foo: "bar"

# POST api.dwolla.com/resource multipart/form-data foo=...
token.post "resource", foo: Faraday::UploadIO.new("/path/to/bar.png", "image/png")

# PUT api.dwolla.com/resource {"foo":"bar"}
token.put "resource", foo: "bar"

# DELETE api.dwolla.com/resource
token.delete "resource"
```

Requests can also be made in parallel:

```ruby
foo, bar = nil
token.in_parallel do
  foo = token.get "/foo"
  bar = token.get "/bar"
end
puts foo # only ready after `in_parallel` block has executed
puts bar # only ready after `in_parallel` block has executed
```

#### Setting headers

To set additional headers on a request you can pass a `Hash` of headers as the 3rd argument.

For example:

```ruby
token.post "customers", { firstName: "John", lastName: "Doe", email: "jd@doe.com" },
                        { 'Idempotency-Key': 'a52fcf63-0730-41c3-96e8-7147b5d1fb01' }
```

## Responses

Requests return a `DwollaV2::Response`.

```ruby
res = token.get "/"
# => #<DwollaV2::Response status=200 headers={"server"=>"cloudflare-nginx", "date"=>"Mon, 28 Mar 2016 15:30:23 GMT", "content-type"=>"application/vnd.dwolla.v1.hal+json; charset=UTF-8", "content-length"=>"150", "connection"=>"close", "set-cookie"=>"__cfduid=d9dcd0f586c166d36cbd45b992bdaa11b1459179023; expires=Tue, 28-Mar-17 15:30:23 GMT; path=/; domain=.dwolla.com; HttpOnly", "x-request-id"=>"69a4e612-5dae-4c52-a6a0-2f921e34a88a", "cf-ray"=>"28ac1f81875941e3-MSP"} {"_links"=>{"events"=>{"href"=>"https://api-sandbox.dwolla.com/events"}, "webhook-subscriptions"=>{"href"=>"https://api-sandbox.dwolla.com/webhook-subscriptions"}}}>

res.status
# => 200

res.headers
# => {"server"=>"cloudflare-nginx", "date"=>"Mon, 28 Mar 2016 15:30:23 GMT", "content-type"=>"application/vnd.dwolla.v1.hal+json; charset=UTF-8", "content-length"=>"150", "connection"=>"close", "set-cookie"=>"__cfduid=d9dcd0f586c166d36cbd45b992bdaa11b1459179023; expires=Tue, 28-Mar-17 15:30:23 GMT; path=/; domain=.dwolla.com; HttpOnly", "x-request-id"=>"69a4e612-5dae-4c52-a6a0-2f921e34a88a", "cf-ray"=>"28ac1f81875941e3-MSP"}

res._links.events.href
# => "https://api-sandbox.dwolla.com/events"
```

## Errors

If the server returns an error, a `DwollaV2::Error` (or one of its subclasses) will be raised.
`DwollaV2::Error`s are similar to `DwollaV2::Response`s.

```ruby
begin
  token.get "/not-found"
rescue DwollaV2::NotFoundError => e
  e
  # => #<DwollaV2::NotFoundError status=404 headers={"server"=>"cloudflare-nginx", "date"=>"Mon, 28 Mar 2016 15:35:32 GMT", "content-type"=>"application/vnd.dwolla.v1.hal+json; profile=\"http://nocarrier.co.uk/profiles/vnd.error/\"; charset=UTF-8", "content-length"=>"69", "connection"=>"close", "set-cookie"=>"__cfduid=da1478bfdf3e56275cd8a6a741866ccce1459179332; expires=Tue, 28-Mar-17 15:35:32 GMT; path=/; domain=.dwolla.com; HttpOnly", "access-control-allow-origin"=>"*", "x-request-id"=>"667fca74-b53d-43db-bddd-50426a011881", "cf-ray"=>"28ac270abca64207-MSP"} {"code"=>"NotFound", "message"=>"The requested resource was not found."}>

  e.status
  # => 404

  e.headers
  # => {"server"=>"cloudflare-nginx", "date"=>"Mon, 28 Mar 2016 15:35:32 GMT", "content-type"=>"application/vnd.dwolla.v1.hal+json; profile=\"http://nocarrier.co.uk/profiles/vnd.error/\"; charset=UTF-8", "content-length"=>"69", "connection"=>"close", "set-cookie"=>"__cfduid=da1478bfdf3e56275cd8a6a741866ccce1459179332; expires=Tue, 28-Mar-17 15:35:32 GMT; path=/; domain=.dwolla.com; HttpOnly", "access-control-allow-origin"=>"*", "x-request-id"=>"667fca74-b53d-43db-bddd-50426a011881", "cf-ray"=>"28ac270abca64207-MSP"}

  e.code
  # => "NotFound"
rescue DwollaV2::Error => e
  # ...
end
```

### `DwollaV2::Error` subclasses:

*See https://docsv2.dwolla.com/#errors for more info.*

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
- `DwollaV2::InvalidAccountStatusError`
- `DwollaV2::InvalidScopesError`
- `DwollaV2::UnsupportedGrantTypeError`
- `DwollaV2::InvalidApplicationStatusError`
- `DwollaV2::InvalidVersionError`
- `DwollaV2::UnsupportedResponseTypeError`
- `DwollaV2::InvalidClientError`
- `DwollaV2::MethodNotAllowedError`
- `DwollaV2::ValidationError`
- `DwollaV2::TooManyRequestsError`
- `DwollaV2::ConflictError`

## Sample code

The following gist contains some sample bootstrapping code:

https://gist.github.com/sausman/df58a196b3bc0381b0e8

If you have any questions regarding your specific implementation we'll do our best to help
at https://discuss.dwolla.com/.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Dwolla/dwolla-v2-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://github.com/Dwolla/dwolla-v2-ruby).

## Changelog

- **1.2.1** - Update sandbox URLs from sandbox => sandbox.
- **1.2.0** - Refer to Client :id as :key in docs/public APIs for consistency.
- **1.1.2** - Add support for `verified_account` and `dwolla_landing` auth flags.
- **1.1.1** - Add `TooManyRequestsError` and `ConflictError` classes.
- **1.1.0** - Support setting headers on a per-request basis.
- **1.0.1** - Set user agent header.
- **1.0.0** - Refactor `Error` class to be more like response, add ability to access keys using methods.
- **0.4.0** - Refactor and document how `DwollaV2::Response` works
- **0.3.1** - better `DwollaV2::Error` error messages
- **0.3.0** - ISO8601 values in response body are converted to `Time` objects
- **0.2.0** - Works with `attr_encrypted`
- **0.1.1** - Handle 500 error with HTML response body when requesting a token
