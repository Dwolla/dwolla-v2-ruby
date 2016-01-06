require "spec_helper"

describe Dwolla::Auth do
  let!(:client) { Dwolla::Client.new :id => "CLIENT_ID", :secret => "CLIENT_SECRET" }
  let!(:params) {{:scope => "a,b,c"}}
  let!(:token_hash) {{:access_token  => "ACCESS_TOKEN"}}
  let!(:error_hash) {{:error => "error_code"}}

  it ".client raises ArgumentError if first arg not Dwolla::Client" do
    expect {
      Dwolla::Auth.client "not a Dwolla::Client"
    }.to raise_error {|e|
      expect(e).to be_a ArgumentError
      expect(e.message).to eq "client must be a Dwolla::Client"
    }
  end

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
    stub_token_request client,
                       {:grant_type => "client_credentials"}.merge(params),
                       {:status => 200, :body => token_hash}
    token = Dwolla::Auth.client client, params
    expect(token).to be_a Dwolla::Token
    expect(token.client).to be client
    expect(token.access_token).to eq token_hash[:access_token]
  end

  it ".client with params (error)" do
    stub_token_request client,
                       {:grant_type => "client_credentials"}.merge(params),
                       {:status => 401, :body => error_hash}
    error = Dwolla::Auth.client client, params
    expect(error).to be_a Dwolla::Error
    expect(error.error).to eq error_hash[:error]
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
end
