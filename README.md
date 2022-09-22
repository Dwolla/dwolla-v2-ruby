# Dwolla SDK for Ruby

![Build Status](https://travis-ci.org/Dwolla/dwolla-v2-ruby.svg)

This repository contains the source code for Dwolla's Ruby-based SDK, which allows developers to interact with Dwolla's server-side API via a Ruby API, with automatic OAuth token management included. Any action that can be performed via an HTTP request can be made using this SDK when executed within a server-side environment.

## Table of Contents

- [Getting Started](#getting-started)
  - [Installation](#installation)
  - [Initialization](#initialization)
- [Making Requests](#making-requests)
  - [Low-level Requests](#low-level-requests)
    - [Setting Headers](#setting-headers)
    - [Responses](#responses)
      - [Success](#success)
      - [Error](#error)
- [Changelog](#changelog)
- [Community](#community)
- [Additional Resources](#additional-resources)


## Getting Started

### Installation

To begin using this SDK, you will first need to download it to your machine. We use [RubyGems](https://rubygems.org/gems/dwolla_v2) to distribute this package.

Add this line to your application's Gemfile:

```ruby
gem 'dwolla_v2', '~> 3.1'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dwolla_v2

### Initialization

Before any API requests can be made, you must first determine which environment you will be using, as well as fetch the application key and secret. To fetch your application key and secret, please visit one of the following links:

* Production: https://dashboard.dwolla.com/applications
* Sandbox: https://dashboard-sandbox.dwolla.com/applications

Finally, you can create an instance of `Client` with `key` and `secret` replaced with the application key and secret that you fetched from one of the aforementioned links, respectively.

```ruby
# config/initializers/dwolla.rb
$dwolla = DwollaV2::Client.new(
  key: ENV["DWOLLA_APP_KEY"],
  secret: ENV["DWOLLA_APP_SECRET"],
  environment: :sandbox # defaults to :production
)
```

#### Configure Faraday (Optional)

Dwolla for Ruby uses [Faraday][faraday] to make HTTP requests. You can configure your own
[Faraday middleware][faraday-middleware] and adapter when configuring your client. Remember to
always include an adapter last, even if you want to use the default adapter.

[faraday]: https://github.com/lostisland/faraday
[faraday-middleware]: https://github.com/lostisland/faraday_middleware

```ruby
# config/initializers/dwolla.rb
$dwolla = DwollaV2::Client.new(
  key: ENV["DWOLLA_APP_KEY"],
  secret: ENV["DWOLLA_APP_SECRET"]
) do |config|

  config.faraday do |faraday|
    faraday.response :logger
    faraday.adapter Faraday.default_adapter
  end
end
```

## Making Requests

Once you've created a `Client`, currently, you can make low-level HTTP requests.

### Low-level Requests

To make low-level HTTP requests, you can use the [`get()`](#get), [`post()`](#post), and [`delete()`](#delete) methods.

#### `GET`
```ruby
# GET api.dwolla.com/resource?foo=bar
$dwolla.get "resource", foo: "bar"
```

#### `POST`
```ruby
# POST api.dwolla.com/resource {"foo":"bar"}
$dwolla.post "resource", foo: "bar"

# POST api.dwolla.com/resource multipart/form-data foo=...
$dwolla.post "resource", foo: Faraday::UploadIO.new("/path/to/bar.png", "image/png")
```

#### `DELETE`
```ruby
# DELETE api.dwolla.com/resource
$dwolla.delete "resource"
```

##### Setting Headers

To set additional headers on a request, you can pass a `Hash` of headers as the 3rd argument.

For example:

```ruby
$dwolla.post "customers", { firstName: "John", lastName: "Doe", email: "jd@doe.com" },
                          { 'Idempotency-Key': 'a52fcf63-0730-41c3-96e8-7147b5d1fb01' }
```

#### Responses

The following snippets demonstrate successful and errored responses from the Dwolla API.

An errored response is returned when Dwolla's servers respond with a status code that is greater than or equal to 400, whereas a successful response is when Dwolla's servers respond with a 200-level status code.

##### Success

Successful requests return a `DwollaV2::Response`.

```ruby
res = $dwolla.get "/"
# => #<DwollaV2::Response response_status=200 response_headers={"server"=>"cloudflare-nginx", "date"=>"Mon, 28 Mar 2016 15:30:23 GMT", "content-type"=>"application/vnd.dwolla.v1.hal+json; charset=UTF-8", "content-length"=>"150", "connection"=>"close", "set-cookie"=>"__cfduid=d9dcd0f586c166d36cbd45b992bdaa11b1459179023; expires=Tue, 28-Mar-17 15:30:23 GMT; path=/; domain=.dwolla.com; HttpOnly", "x-request-id"=>"69a4e612-5dae-4c52-a6a0-2f921e34a88a", "cf-ray"=>"28ac1f81875941e3-MSP"} {"_links"=>{"events"=>{"href"=>"https://api-sandbox.dwolla.com/events"}, "webhook-subscriptions"=>{"href"=>"https://api-sandbox.dwolla.com/webhook-subscriptions"}}}>

res.response_status
# => 200

res.response_headers
# => {"server"=>"cloudflare-nginx", "date"=>"Mon, 28 Mar 2016 15:30:23 GMT", "content-type"=>"application/vnd.dwolla.v1.hal+json; charset=UTF-8", "content-length"=>"150", "connection"=>"close", "set-cookie"=>"__cfduid=d9dcd0f586c166d36cbd45b992bdaa11b1459179023; expires=Tue, 28-Mar-17 15:30:23 GMT; path=/; domain=.dwolla.com; HttpOnly", "x-request-id"=>"69a4e612-5dae-4c52-a6a0-2f921e34a88a", "cf-ray"=>"28ac1f81875941e3-MSP"}

res._links.events.href
# => "https://api-sandbox.dwolla.com/events"
```

##### Error

If the server returns an error, a `DwollaV2::Error` (or one of its subclasses) will be raised.
`DwollaV2::Error`s are similar to `DwollaV2::Response`s.

```ruby
begin
  $dwolla.get "/not-found"
rescue DwollaV2::NotFoundError => e
  e
  # => #<DwollaV2::NotFoundError response_status=404 response_headers={"server"=>"cloudflare-nginx", "date"=>"Mon, 28 Mar 2016 15:35:32 GMT", "content-type"=>"application/vnd.dwolla.v1.hal+json; profile=\"http://nocarrier.co.uk/profiles/vnd.error/\"; charset=UTF-8", "content-length"=>"69", "connection"=>"close", "set-cookie"=>"__cfduid=da1478bfdf3e56275cd8a6a741866ccce1459179332; expires=Tue, 28-Mar-17 15:35:32 GMT; path=/; domain=.dwolla.com; HttpOnly", "access-control-allow-origin"=>"*", "x-request-id"=>"667fca74-b53d-43db-bddd-50426a011881", "cf-ray"=>"28ac270abca64207-MSP"} {"code"=>"NotFound", "message"=>"The requested resource was not found."}>

  e.response_status
  # => 404

  e.response_headers
  # => {"server"=>"cloudflare-nginx", "date"=>"Mon, 28 Mar 2016 15:35:32 GMT", "content-type"=>"application/vnd.dwolla.v1.hal+json; profile=\"http://nocarrier.co.uk/profiles/vnd.error/\"; charset=UTF-8", "content-length"=>"69", "connection"=>"close", "set-cookie"=>"__cfduid=da1478bfdf3e56275cd8a6a741866ccce1459179332; expires=Tue, 28-Mar-17 15:35:32 GMT; path=/; domain=.dwolla.com; HttpOnly", "access-control-allow-origin"=>"*", "x-request-id"=>"667fca74-b53d-43db-bddd-50426a011881", "cf-ray"=>"28ac270abca64207-MSP"}

  e.code
  # => "NotFound"
rescue DwollaV2::Error => e
  # ...
end
```


###### `DwollaV2::Error` subclasses:

_See https://developers.dwolla.com/api-reference#errors for more info._

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

## Changelog

- **3.1.1** - Fix deprecation warning on Faraday::Connection#authorization (Thanks [@javierjulio](https://github.com/javierjulio)!). [#60](https://github.com/Dwolla/dwolla-v2-ruby/pull/60)
- **3.1.0** - Added `DwollaV2::MaxNumberOfResourcesError` (Thanks [@paulyeo21](https://github.com/paulyeo21)!). [#54](https://github.com/Dwolla/dwolla-v2-ruby/pull/54)
- **3.0.1** - Update dependencies (Thanks [@sealabcore](https://github.com/sealabcore)!). [#48](https://github.com/Dwolla/dwolla-v2-ruby/pull/48)
- **3.0.0** - Add integrations auth functions
- **3.0.0.beta1** - Add token management functionality to `DwollaV2::Client`
- **2.2.1** - Update dependencies
- **2.2.0** - Change token url from `www.dwolla.com/oauth/v2/token` to `accounts.dwolla.com/token`
- **2.1.0** - Ensure `Time.iso8601` is defined so timestamps get parsed. [#38](https://github.com/Dwolla/dwolla-v2-ruby/pull/38) (Thanks [@javierjulio](https://github.com/javierjulio)!)
- **2.0.3** - Add `DuplicateResourceError` [#34](https://github.com/Dwolla/dwolla-v2-ruby/pull/34) (Thanks [@javierjulio](https://github.com/javierjulio)!)
- **2.0.2** - Fix bug in [#30](https://github.com/Dwolla/dwolla-v2-ruby/pull/30) (Thanks again [@sobrinho](https://github.com/sobrinho)!
- **2.0.1** - Fix bugs in [#27](https://github.com/Dwolla/dwolla-v2-ruby/pull/27) + [#28](https://github.com/Dwolla/dwolla-v2-ruby/pull/28) (Thanks [@sobrinho](https://github.com/sobrinho)!)
- **2.0.0**
- Rename `DwollaV2::Response` `#status` => `#response_status`, `#headers` => `#response_headers` to prevent
  [conflicts with response body properties](https://discuss.dwolla.com/t/document-change-or-more-clarifiation/3964).
- Remove support for Ruby versions < 2 ([Bump public_suffix dependency version](https://github.com/Dwolla/dwolla-v2-ruby/pull/18#discussion_r108028135)).
- **1.2.3** - Implement `#empty?` on `DwollaV2::Token` to allow it to be passed to ActiveRecord constructor.
- **1.2.2** - Strip domain from URLs provided to `token.*` methods.
- **1.2.1** - Update sandbox URLs from uat => sandbox.
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

## Community
* If you have any feedback, please reach out to us on [our forums](https://discuss.dwolla.com/) or by [creating a GitHub issue](https://github.com/Dwolla/dwolla-v2-ruby/issues/new).
* If you would like to contribute to this library, [bug reports](https://github.com/Dwolla/dwolla-v2-ruby/issues) and [pull requests](https://github.com/Dwolla/dwolla-v2-ruby/pulls) are always appreciated!
  * After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. 
  * To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Docker

If you prefer to use Docker to run dwolla-v2-python locally, a Dockerfile is included at the root directory.
Follow these instructions from [Docker's website](https://docs.docker.com/build/hellobuild/) to create a Docker image from the Dockerfile, and run it.
  
## Additional Resources

To learn more about Dwolla and how to integrate our product with your application, please consider visiting the following resources and becoming a member of our community!

* [Dwolla](https://www.dwolla.com/)
* [Dwolla Developers](https://developers.dwolla.com/)
* [SDKs and Tools](https://developers.dwolla.com/sdks-tools)
  * [Dwolla SDK for C#](https://github.com/Dwolla/dwolla-v2-csharp)
  * [Dwolla SDK for Kotlin](https://github.com/Dwolla/dwolla-v2-kotlin)
  * [Dwolla SDK for Node](https://github.com/Dwolla/dwolla-v2-node)
  * [Dwolla SDK for PHP](https://github.com/Dwolla/dwolla-v2-php)
  * [Dwolla SDK for Python](https://github.com/Dwolla/dwolla-v2-python)
* [Developer Support Forum](https://discuss.dwolla.com/)


