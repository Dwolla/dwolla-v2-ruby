require "spec_helper"

describe Dwolla::Auth do
  let!(:client) { Dwolla::Client.new :id => "CLIENT_ID", :secret => "CLIENT_SECRET" }
  let!(:token_hash) {{:access_token  => "ACCESS_TOKEN"}}
  let!(:error_hash) {{:error => "error_code"}}

  it ".client with no params (success)" do
    stub_token_request client,
                       {:grant_type => "client_credentials"},
                       {:status => 200, :body => token_hash}
    token = Dwolla::Auth.client client
    expect(token).to be_a Dwolla::Token
    expect(token.client).to be client
    expect(token.access_token).to eq token_hash[:access_token]
  end

  it ".client with no params (error)" do
    stub_token_request client,
                       {:grant_type => "client_credentials"},
                       {:status => 401, :body => error_hash}
    error = Dwolla::Auth.client client
    expect(error).to be_a Dwolla::Error
    expect(error.error).to eq error_hash[:error]
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
    error = Dwolla::Auth.client client, params
    expect(error).to be_a Dwolla::Error
    expect(error.error).to eq error_hash[:error]
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

  it "#url" do
    params = {:redirect_uri => "REDIRECT_URI", :scope => "a,b,c", :state => "STATE"}
    auth = Dwolla::Auth.new client, params
    expect(auth.url).to eq uri_with_query(client.auth_url, params)
  end

  private

  def stub_token_request client, params, response
    stub_request(:post, token_url(client))
      .with(:headers => {"Content-Type" => "application/x-www-form-urlencoded"},
            :body => URI.encode_www_form(params))
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
