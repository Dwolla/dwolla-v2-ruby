require "spec_helper"

describe Dwolla::Auth do
  let!(:client) { Dwolla::Client.new :id => "CLIENT_ID", :secret => "CLIENT_SECRET" }
  let!(:token_hash) {{:access_token  => "ACCESS_TOKEN"}}
  let!(:error_hash) {{:error => "error_code"}}

  it ".client (success)" do
    stub_token_request client,
                       {:grant_type => "client_credentials"},
                       {:status => 200, :body => token_hash}
    token = Dwolla::Auth.client client
    expect(token).to be_a Dwolla::Token
    expect(token.client).to be client
    expect(token.access_token).to eq token_hash[:access_token]
  end

  it ".client (error)" do
    stub_token_request client,
                       {:grant_type => "client_credentials"},
                       {:status => 401, :body => error_hash}
    expect {
      Dwolla::Auth.client client
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::Error
      expect(e.error).to eq error_hash[:error]
    }
  end

  it ".client with params (success)" do
    params = {:scope => "a,b,c"}
    stub_token_request client,
                       {:grant_type => "client_credentials"}.merge(params),
                       {:status => 200, :body => token_hash}
    token = Dwolla::Auth.client client, params
    expect(token).to be_a Dwolla::Token
    expect(token.client).to be client
    expect(token.access_token).to eq token_hash[:access_token]
  end

  it ".client with params (error)" do
    params = {:scope => "a,b,c"}
    stub_token_request client,
                       {:grant_type => "client_credentials"}.merge(params),
                       {:status => 401, :body => error_hash}
    expect {
      Dwolla::Auth.client client, params
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::Error
      expect(e.error).to eq error_hash[:error]
    }
  end

  it ".refresh raises ArgumentError if second arg isn't Dwolla::Token" do
    expect {
      Dwolla::Auth.refresh client, "not a Dwolla::Token"
    }.to raise_error {|e|
      expect(e).to be_a ArgumentError
      expect(e.message).to eq "Dwolla::Token required"
    }
  end

  it ".refresh raises ArgumentError if token has no refresh_token" do
    token = Dwolla::Token.new client, {}
    expect {
      Dwolla::Auth.refresh client, token
    }.to raise_error {|e|
      expect(e).to be_a ArgumentError
      expect(e.message).to eq "invalid refresh_token"
    }
  end

  it ".refresh (success)" do
    old_token = Dwolla::Token.new client, :refresh_token => "REFRESH_TOKEN"
    stub_token_request client,
                       {:grant_type => "refresh_token", :refresh_token => old_token.refresh_token},
                       {:status => 200, :body => token_hash}
    token = Dwolla::Auth.refresh client, old_token
    expect(token).to be_a Dwolla::Token
    expect(token.client).to be client
    expect(token.access_token).to eq token_hash[:access_token]
  end

  it ".refresh (error)" do
    old_token = Dwolla::Token.new client, :refresh_token => "REFRESH_TOKEN"
    stub_token_request client,
                       {:grant_type => "refresh_token", :refresh_token => old_token.refresh_token},
                       {:status => 401, :body => error_hash}
    expect {
      Dwolla::Auth.refresh client, old_token
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::Error
      expect(e.error).to eq error_hash[:error]
    }
  end

  it ".refresh with params (success)" do
    old_token = Dwolla::Token.new client, :refresh_token => "REFRESH_TOKEN"
    params = {:scope => "a,b,c"}
    stub_token_request client,
                       {:grant_type => "refresh_token", :refresh_token => old_token.refresh_token}.merge(params),
                       {:status => 200, :body => token_hash}
    token = Dwolla::Auth.refresh client, old_token, params
    expect(token).to be_a Dwolla::Token
    expect(token.client).to be client
    expect(token.access_token).to eq token_hash[:access_token]
  end

  it ".refresh with params (error)" do
    old_token = Dwolla::Token.new client, :refresh_token => "REFRESH_TOKEN"
    params = {:scope => "a,b,c"}
    stub_token_request client,
                       {:grant_type => "refresh_token", :refresh_token => old_token.refresh_token}.merge(params),
                       {:status => 401, :body => error_hash}
    expect {
      Dwolla::Auth.refresh client, old_token, params
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::Error
      expect(e.error).to eq error_hash[:error]
    }
  end

  it "#initialize sets client" do
    auth = Dwolla::Auth.new client
    expect(auth.client).to be client
  end

  it "#initialize sets redirect_uri" do
    redirect_uri = "REDIRECT_URI"
    auth = Dwolla::Auth.new client, :redirect_uri => redirect_uri
    expect(auth.redirect_uri).to eq redirect_uri
  end

  it "#initialize sets scope" do
    scope = "a,b,c"
    auth = Dwolla::Auth.new client, :scope => scope
    expect(auth.scope).to eq scope
  end

  it "#initialize sets state" do
    state = "STATE"
    auth = Dwolla::Auth.new client, :state => state
    expect(auth.state).to eq state
  end

  it "#initialize freezes auth" do
    auth = Dwolla::Auth.new client
    expect(auth.frozen?).to be true
  end

  it "#url" do
    params = {:scope => "a,b,c", :state => "STATE"}
    auth = Dwolla::Auth.new client, params
    expect(auth.url).to eq uri_with_query(client.auth_url, params)
  end

  it "#url with redirect_uri" do
    params = {:redirect_uri => "REDIRECT_URI", :scope => "a,b,c", :state => "STATE"}
    auth = Dwolla::Auth.new client, params
    expect(auth.url).to eq uri_with_query(client.auth_url, params)
  end

  it "#callback raises ArgumentError if state does not match" do
    auth = Dwolla::Auth.new client, :state => "STATE"
    expect {
      auth.callback :state => "WRONG", :code => "CODE"
    }.to raise_error {|e|
      expect(e).to be_a ArgumentError
      expect(e.message).to eq "state does not match"
    }
  end

  it "#callback raises ArgumentError if no code" do
    auth = Dwolla::Auth.new client, :state => "STATE"
    expect {
      auth.callback :state => auth.state
    }.to raise_error {|e|
      expect(e).to be_a ArgumentError
      expect(e.message).to eq "code is required"
    }
  end

  it "#callback (success)" do
    auth = Dwolla::Auth.new client, :state => "STATE"
    code = "CODE"
    stub_token_request client,
                       {:grant_type => "authorization_code"}.merge(:code => code),
                       {:status => 200, :body => token_hash}
    token = auth.callback :code => code, :state => auth.state
    expect(token).to be_a Dwolla::Token
    expect(token.client).to be client
    expect(token.access_token).to eq token_hash[:access_token]
  end

  it "#callback (error)" do
    auth = Dwolla::Auth.new client, :state => "STATE"
    code = "CODE"
    stub_token_request client,
                       {:grant_type => "authorization_code"}.merge(:code => code),
                       {:status => 401, :body => error_hash}
    expect {
      auth.callback :code => code, :state => auth.state
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::Error
      expect(e.error).to eq error_hash[:error]
    }
  end

  it "#callback with redirect_uri (success)" do
    auth = Dwolla::Auth.new client, :state => "STATE", :redirect_uri => "REDIRECT_URI"
    code = "CODE"
    stub_token_request client,
                       {:grant_type => "authorization_code"}.merge(:code => code, :redirect_uri => auth.redirect_uri),
                       {:status => 200, :body => token_hash}
    token = auth.callback :code => code, :state => auth.state
    expect(token).to be_a Dwolla::Token
    expect(token.client).to be client
    expect(token.access_token).to eq token_hash[:access_token]
  end

  it "#callback with redirect_uri (error)" do
    auth = Dwolla::Auth.new client, :state => "STATE", :redirect_uri => "REDIRECT_URI"
    code = "CODE"
    stub_token_request client,
                       {:grant_type => "authorization_code"}.merge(:code => code, :redirect_uri => auth.redirect_uri),
                       {:status => 401, :body => error_hash}
    expect {
      auth.callback :code => code, :state => auth.state
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::Error
      expect(e.error).to eq error_hash[:error]
    }
  end

  private

  def stub_token_request client, params, response
    stub_request(:post, token_url(client))
      .with(:headers => {"Content-Type" => "application/x-www-form-urlencoded"},
            :body => params)
      .to_return(:status => response[:status],
                 :body => JSON.generate(response[:body]))
  end

  def token_url client
    url = client.token_url.split "/"
    url[2] = "#{client.id}:#{client.secret}@#{url[2]}"
    url.join "/"
  end

  def uri_with_query uri, query
    "#{uri}?#{URI.encode_www_form(query)}"
  end
end
