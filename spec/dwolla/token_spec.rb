require "spec_helper"

describe Dwolla::Token do
  let!(:client) { Dwolla::Client.new :id => "CLIENT_ID", :secret => "CLIENT_SECRET" }
  let!(:params) {{
    :access_token  => "ACCESS_TOKEN",
    :refresh_token => "REFRESH_TOKEN",
    :expires_in    => 123,
    :scope         => "a,b,c",
    :account_id    => "92e19aa4-93d4-49e7-b3e6-32f6d7a2a64d",
    :unknown_param => "?"
  }}

  it "#initialize sets client" do
    token = Dwolla::Token.new client, params
    expect(token.client).to be client
  end

  it "#initialize sets access_token" do
    token = Dwolla::Token.new client, params
    expect(token.access_token).to eq params[:access_token]
  end

  it "#initialize sets refresh_token" do
    token = Dwolla::Token.new client, params
    expect(token.refresh_token).to eq params[:refresh_token]
  end

  it "#initialize sets expires_in" do
    token = Dwolla::Token.new client, params
    expect(token.expires_in).to eq params[:expires_in]
  end

  it "#initialize sets scope" do
    token = Dwolla::Token.new client, params
    expect(token.scope).to eq params[:scope]
  end

  it "#initialize sets account_id" do
    token = Dwolla::Token.new client, params
    expect(token.account_id).to eq params[:account_id]
  end

  it "#initialize freezes token" do
    token = Dwolla::Token.new client, params
    expect(token.frozen?).to be true
  end

  it "#stringify_keys" do
    token = Dwolla::Token.new client, params
    expect(token.stringify_keys).to eq({
      "access_token"  => params[:access_token],
      "refresh_token" => params[:refresh_token],
      "expires_in"    => params[:expires_in],
      "scope"         => params[:scope],
      "account_id"    => params[:account_id]
    })
  end

  it "#stringify_keys rejects nil values" do
    token = Dwolla::Token.new client, params.merge(:account_id => nil)
    expect(token.stringify_keys).to eq({
      "access_token"  => params[:access_token],
      "refresh_token" => params[:refresh_token],
      "expires_in"    => params[:expires_in],
      "scope"         => params[:scope]
    })
  end
end
