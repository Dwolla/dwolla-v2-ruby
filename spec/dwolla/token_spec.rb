require "spec_helper"

describe Dwolla::Token do
  let!(:client) { Dwolla::Client.new :id => "CLIENT_ID", :secret => "CLIENT_SECRET" }
  let!(:params) {{
    :access_token  => "ACCESS_TOKEN",
    :refresh_token => "REFRESH_TOKEN",
    :expires_in    => 123,
    :account_id    => "92e19aa4-93d4-49e7-b3e6-32f6d7a2a64d",
    :unknown_param => "?"
  }}

  it "#initialize sets client" do
    token = Dwolla::Token.new client, params
    expect(token.client).to be client
  end

  it "#initialize raises ArgumentError if client is nil" do
    expect {
      Dwolla::Token.new nil, params
    }.to raise_error {|e|
      expect(e).to be_a ArgumentError
      expect(e.message).to eq "client must be a Dwolla::Client"
    }
  end

  it "#initialize raises ArgumentError if client is not a Dwolla::Client" do
    expect {
      Dwolla::Token.new "not a Dwolla::Client", params
    }.to raise_error {|e|
      expect(e).to be_a ArgumentError
      expect(e.message).to eq "client must be a Dwolla::Client"
    }
  end

  it "#initialize sets access_token" do
    token = Dwolla::Token.new client, params
    expect(token.access_token).to eq params[:access_token]
  end

  it "#initialize raises ArgumentError if access_token is nil" do
    expect {
      Dwolla::Token.new client, params.merge(:access_token => nil)
    }.to raise_error {|e|
      expect(e).to be_a ArgumentError
      expect(e.message).to eq "access_token must be a String"
    }
  end

  it "#initialize raises ArgumentError if access_token is not a String" do
    expect {
      Dwolla::Token.new client, params.merge(:access_token => 123)
    }.to raise_error {|e|
      expect(e).to be_a ArgumentError
      expect(e.message).to eq "access_token must be a String"
    }
  end

  it "#initialize sets refresh_token" do
    token = Dwolla::Token.new client, params
    expect(token.refresh_token).to eq params[:refresh_token]
  end

  it "#initialize allows nil refresh_token" do
    Dwolla::Token.new client, params.merge(:refresh_token => nil)
  end

  it "#initialize raises ArgumentError if refresh_token is not a String" do
    expect {
      Dwolla::Token.new client, params.merge(:refresh_token => 123)
    }.to raise_error {|e|
      expect(e).to be_a ArgumentError
      expect(e.message).to eq "refresh_token must be a String"
    }
  end

  it "#initialize sets expires_in" do
    token = Dwolla::Token.new client, params
    expect(token.expires_in).to eq params[:expires_in]
  end

  it "#initialize allows nil expires_in" do
    Dwolla::Token.new client, params.merge(:expires_in => nil)
  end

  it "#initialize raises ArgumentError if expires_in is not an Integer" do
    expect {
      Dwolla::Token.new client, params.merge(:expires_in => "not an Integer")
    }.to raise_error {|e|
      expect(e).to be_a ArgumentError
      expect(e.message).to eq "expires_in must be an Integer"
    }
  end

  it "#initialize sets account_id" do
    token = Dwolla::Token.new client, params
    expect(token.account_id).to eq params[:account_id]
  end

  it "#initialize allows nil account_id" do
    Dwolla::Token.new client, params.merge(:account_id => nil)
  end

  it "#initialize raises ArgumentError if account_id is not a String" do
    expect {
      Dwolla::Token.new client, params.merge(:account_id => 123)
    }.to raise_error {|e|
      expect(e).to be_a ArgumentError
      expect(e.message).to eq "account_id must be a String"
    }
  end

  it "#stringify_keys" do
    token = Dwolla::Token.new client, params
    expect(token.stringify_keys).to eq({
      "client"        => client,
      "access_token"  => "ACCESS_TOKEN",
      "refresh_token" => "REFRESH_TOKEN",
      "expires_in"    => 123,
      "account_id"    => "92e19aa4-93d4-49e7-b3e6-32f6d7a2a64d"
    })
  end
end
