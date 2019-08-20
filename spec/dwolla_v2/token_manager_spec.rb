require "spec_helper"

describe DwollaV2::TokenManager do
  let!(:client) { DwollaV2::Client.new(key: "key", secret: "secret") }
  let!(:token_manager) { DwollaV2::TokenManager.new(client) }
  let!(:new_access_token) { "new_access_token" }
  let!(:expires_in) { 3_600 }

  before(:each) do
    stub_request(:post, client.token_url)
        .with(:basic_auth => [client.id, client.secret],
              :headers => {"Content-Type" => "application/x-www-form-urlencoded"},
              :body => {"grant_type" => "client_credentials"})
        .to_return(:status => 200,
                   :headers => {"Content-Type" => "application/json"},
                   :body => JSON.generate({ access_token: new_access_token, expires_in: expires_in }))
  end

  it "#get_token gets initial token" do
    expect(token_manager.get_token).to be_a DwollaV2::Token
    expect(token_manager.get_token.access_token).to eq new_access_token
  end

  it "#get_token re-uses fresh token" do
    expect(token_manager.get_token).to be token_manager.get_token
  end

  it "#get_token refreshes expired token" do
    token_manager.get_token
    token_manager.instance_variable_get(:@wrapped_token).instance_variable_set(:@expires_at, Time.now - 1)
    token_manager.instance_variable_get(:@wrapped_token).instance_variable_set(:@token, client.tokens.new(access_token: "old"))
    
    expect(token_manager.get_token).to be_a DwollaV2::Token
    expect(token_manager.get_token.access_token).to eq new_access_token
  end
end

describe DwollaV2::TokenWrapper do
  let!(:client) { DwollaV2::Client.new(key: "key", secret: "secret") }
  
  it "#is_expired? returns false" do
    wrapped_token = DwollaV2::TokenWrapper.new(client.tokens.new(expires_in: 3_600))

    expect(wrapped_token.is_expired?).to be false
  end

  it "#is_expired? returns true" do
    wrapped_token = DwollaV2::TokenWrapper.new(client.tokens.new(expires_in: -3_600))

    expect(wrapped_token.is_expired?).to be true
  end

  it "#is_expired? returns true if within leeway period (60 seconds)" do
    wrapped_token = DwollaV2::TokenWrapper.new(client.tokens.new(expires_in: 30))

    expect(wrapped_token.is_expired?).to be true
  end
end
