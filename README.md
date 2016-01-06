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
$dwolla = Dwolla::Client.new :id => "CLIENT_ID", :secret => "CLIENT_SECRET"
```

#### Configuration (optional)

Use the sandbox environment:

```ruby
$dwolla.configure :sandbox
```

Register an `on_grant` callback:

```ruby
$dwolla.on_grant do |token|
  YourDwollaTokenData.create! token
end
```

Configure [Faraday](https://github.com/lostisland/faraday):

```ruby
$dwolla.conn do |faraday|
  faraday.response :logger
  faraday.adapter  Faraday.default_adapter
end
```

#### Authorization

Get an application token:

```ruby
$dwolla.auths.client :scope => "a,b,c"
```

Get an account token:

```ruby
class YourDwollaAuthController < ApplicationController
  def authorize
    redirect_to auth.url
  end

  def callback
    token = auth.callback :code => params[:code],
                          :state => params[:state]
    session[:dwolla_account_id] = token.account_id
  end

  private

  def auth
    $dwolla.auths.new :redirect_uri => "https://yoursite.com/callback",
                      :scope => "a,b,c",
                      :state => (session[:dwolla_auth_state] ||= SecureRandom.hex)
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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dwolla.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
