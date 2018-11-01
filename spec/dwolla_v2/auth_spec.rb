require "spec_helper"

describe DwollaV2::Auth do
  let!(:on_grant_spy) { spy "on_grant" }
  let!(:client) {
    DwollaV2::Client.new(:id => "CLIENT_ID", :secret => "CLIENT_SECRET") do |config|
      config.on_grant {|token| on_grant_spy.call(token) }
    end
  }
  let!(:token_hash) {{:access_token  => "ACCESS_TOKEN"}}
  let!(:error_hash) {{:error => "error_code"}}

  it ".client (success) with no client.on_grant" do
    client_with_no_on_grant = DwollaV2::Client.new(:id => "CLIENT_ID", :secret => "CLIENT_SECRET")
    stub_token_request client_with_no_on_grant,
                       {:grant_type => "client_credentials"},
                       {:status => 200, :body => token_hash}
    token = DwollaV2::Auth.client client_with_no_on_grant
    expect(token).to be_a DwollaV2::Token
    expect(token.client).to be client_with_no_on_grant
    expect(token.access_token).to eq token_hash[:access_token]
  end

  it ".client (success)" do
    stub_token_request client,
                       {:grant_type => "client_credentials"},
                       {:status => 200, :body => token_hash}
    token = DwollaV2::Auth.client client
    expect(token).to be_a DwollaV2::Token
    expect(token.client).to be client
    expect(token.access_token).to eq token_hash[:access_token]
    expect(on_grant_spy).to have_received(:call).with(token)
  end

  it ".client (error)" do
    stub_token_request client,
                       {:grant_type => "client_credentials"},
                       {:status => 401, :body => error_hash}
    expect {
      DwollaV2::Auth.client client
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::Error
      expect(e.error).to eq error_hash[:error]
    }
  end

  it ".client with params (success)" do
    params = {:scope => "a,b,c"}
    stub_token_request client,
                       {:grant_type => "client_credentials"}.merge(params),
                       {:status => 200, :body => token_hash}
    token = DwollaV2::Auth.client client, params
    expect(token).to be_a DwollaV2::Token
    expect(token.client).to be client
    expect(token.access_token).to eq token_hash[:access_token]
    expect(on_grant_spy).to have_received(:call).with(token)
  end

  it ".client with params (error)" do
    params = {:scope => "a,b,c"}
    stub_token_request client,
                       {:grant_type => "client_credentials"}.merge(params),
                       {:status => 401, :body => error_hash}
    expect {
      DwollaV2::Auth.client client, params
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::Error
      expect(e.error).to eq error_hash[:error]
    }
  end

  it ".refresh raises ArgumentError if no refresh_token" do
    token = {}
    expect {
      DwollaV2::Auth.refresh client, token
    }.to raise_error {|e|
      expect(e).to be_a ArgumentError
      expect(e.message).to eq "invalid refresh_token"
    }
  end

  it ".refresh uses refresh_token method before key" do
    old_token = Class.new do
      def [](key); raise "should try method before key"; end
      def refresh_token; "REFRESH_TOKEN"; end
    end.new
    stub_token_request client,
                       {:grant_type => "refresh_token", :refresh_token => old_token.refresh_token},
                       {:status => 200, :body => token_hash}
    token = DwollaV2::Auth.refresh client, old_token
    expect(token).to be_a DwollaV2::Token
    expect(token.client).to be client
    expect(token.access_token).to eq token_hash[:access_token]
    expect(on_grant_spy).to have_received(:call).with(token)
  end

  it ".refresh (success)" do
    old_token = {:refresh_token => "REFRESH_TOKEN"}
    stub_token_request client,
                       {:grant_type => "refresh_token", :refresh_token => old_token[:refresh_token]},
                       {:status => 200, :body => token_hash}
    token = DwollaV2::Auth.refresh client, old_token
    expect(token).to be_a DwollaV2::Token
    expect(token.client).to be client
    expect(token.access_token).to eq token_hash[:access_token]
    expect(on_grant_spy).to have_received(:call).with(token)
  end

  it ".refresh (error)" do
    old_token = {:refresh_token => "REFRESH_TOKEN"}
    stub_token_request client,
                       {:grant_type => "refresh_token", :refresh_token => old_token[:refresh_token]},
                       {:status => 401, :body => error_hash}
    expect {
      DwollaV2::Auth.refresh client, old_token
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::Error
      expect(e.error).to eq error_hash[:error]
    }
  end

  it ".refresh with params (success)" do
    old_token = {:refresh_token => "REFRESH_TOKEN"}
    params = {:scope => "a,b,c"}
    stub_token_request client,
                       {:grant_type => "refresh_token", :refresh_token => old_token[:refresh_token]}.merge(params),
                       {:status => 200, :body => token_hash}
    token = DwollaV2::Auth.refresh client, old_token, params
    expect(token).to be_a DwollaV2::Token
    expect(token.client).to be client
    expect(token.access_token).to eq token_hash[:access_token]
    expect(on_grant_spy).to have_received(:call).with(token)
  end

  it ".refresh with params (error)" do
    old_token = {:refresh_token => "REFRESH_TOKEN"}
    params = {:scope => "a,b,c"}
    stub_token_request client,
                       {:grant_type => "refresh_token", :refresh_token => old_token[:refresh_token]}.merge(params),
                       {:status => 401, :body => error_hash}
    expect {
      DwollaV2::Auth.refresh client, old_token, params
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::Error
      expect(e.error).to eq error_hash[:error]
    }
  end

  it "#initialize sets client" do
    auth = DwollaV2::Auth.new client
    expect(auth.client).to be client
  end

  it "#initialize sets redirect_uri" do
    redirect_uri = "REDIRECT_URI"
    auth = DwollaV2::Auth.new client, :redirect_uri => redirect_uri
    expect(auth.redirect_uri).to eq redirect_uri
  end

  it "#initialize sets scope" do
    scope = "a,b,c"
    auth = DwollaV2::Auth.new client, :scope => scope
    expect(auth.scope).to eq scope
  end

  it "#initialize sets state" do
    state = "STATE"
    auth = DwollaV2::Auth.new client, :state => state
    expect(auth.state).to eq state
  end

  it "#initialize sets verified_account" do
    verified_account = true
    auth = DwollaV2::Auth.new client, :verified_account => verified_account
    expect(auth.verified_account).to eq verified_account
  end

  it "#initialize sets dwolla_landing" do
    dwolla_landing = "register"
    auth = DwollaV2::Auth.new client, :dwolla_landing => dwolla_landing
    expect(auth.dwolla_landing).to eq dwolla_landing
  end

  it "#initialize freezes auth" do
    auth = DwollaV2::Auth.new client
    expect(auth.frozen?).to be true
  end

  it "#url" do
    required_params = {:response_type => "code", :client_id => client.id}
    optional_params = {:scope => "a,b,c", :state => "STATE", :verified_account => true, :dwolla_landing => "register"}
    auth = DwollaV2::Auth.new client, optional_params
    expect(auth.url).to eq uri_with_query(client.auth_url, required_params.merge(optional_params))
  end

  it "#url with redirect_uri" do
    required_params = {:response_type => "code", :client_id => client.id}
    optional_params = {:redirect_uri => "REDIRECT_URI", :scope => "a,b,c", :state => "STATE", :verified_account => true, :dwolla_landing => "register"}
    auth = DwollaV2::Auth.new client, optional_params
    expect(auth.url).to eq uri_with_query(client.auth_url, required_params.merge(optional_params))
  end

  it "#callback raises ArgumentError if state does not match" do
    auth = DwollaV2::Auth.new client, :state => "STATE"
    expect {
      auth.callback :state => "WRONG", :code => "CODE"
    }.to raise_error {|e|
      expect(e).to be_a ArgumentError
      expect(e.message).to eq "state does not match"
    }
  end

  it "#callback raises DwollaV2::Error if error" do
    error = "ERROR"
    auth = DwollaV2::Auth.new client, :state => "STATE"
    expect {
      auth.callback :state => auth.state, :error => error
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::Error
      expect(e.error).to eq error
    }
  end

  it "#callback raises ArgumentError if no code" do
    auth = DwollaV2::Auth.new client, :state => "STATE"
    expect {
      auth.callback :state => auth.state
    }.to raise_error {|e|
      expect(e).to be_a ArgumentError
      expect(e.message).to eq "code is required"
    }
  end

  it "#callback (success)" do
    auth = DwollaV2::Auth.new client, :state => "STATE"
    code = "CODE"
    stub_token_request client,
                       {:grant_type => "authorization_code"}.merge(:code => code),
                       {:status => 200, :body => token_hash}
    token = auth.callback :code => code, :state => auth.state
    expect(token).to be_a DwollaV2::Token
    expect(token.client).to be client
    expect(token.access_token).to eq token_hash[:access_token]
    expect(on_grant_spy).to have_received(:call).with(token)
  end

  it "#callback (error)" do
    auth = DwollaV2::Auth.new client, :state => "STATE"
    code = "CODE"
    stub_token_request client,
                       {:grant_type => "authorization_code"}.merge(:code => code),
                       {:status => 401, :body => error_hash}
    expect {
      auth.callback :code => code, :state => auth.state
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::Error
      expect(e.error).to eq error_hash[:error]
    }
  end

  it "#callback with redirect_uri (success)" do
    auth = DwollaV2::Auth.new client, :state => "STATE", :redirect_uri => "REDIRECT_URI"
    code = "CODE"
    stub_token_request client,
                       {:grant_type => "authorization_code"}.merge(:code => code, :redirect_uri => auth.redirect_uri),
                       {:status => 200, :body => token_hash}
    token = auth.callback :code => code, :state => auth.state
    expect(token).to be_a DwollaV2::Token
    expect(token.client).to be client
    expect(token.access_token).to eq token_hash[:access_token]
    expect(on_grant_spy).to have_received(:call).with(token)
  end

  it "#callback with redirect_uri (error)" do
    auth = DwollaV2::Auth.new client, :state => "STATE", :redirect_uri => "REDIRECT_URI"
    code = "CODE"
    stub_token_request client,
                       {:grant_type => "authorization_code"}.merge(:code => code, :redirect_uri => auth.redirect_uri),
                       {:status => 401, :body => error_hash}
    expect {
      auth.callback :code => code, :state => auth.state
    }.to raise_error {|e|
      expect(e).to be_a DwollaV2::Error
      expect(e.error).to eq error_hash[:error]
    }
  end

  private

  def stub_token_request client, params, response
    stub_request(:post, client.token_url)
      .with(:basic_auth => [client.id, client.secret],
            :headers => {"Content-Type" => "application/x-www-form-urlencoded"},
            :body => params)
      .to_return(:status => response[:status],
                 :headers => {"Content-Type" => "application/json"},
                 :body => JSON.generate(response[:body]))
  end

  def uri_with_query uri, query
    "#{uri}?#{URI.encode_www_form(query)}"
  end
end
