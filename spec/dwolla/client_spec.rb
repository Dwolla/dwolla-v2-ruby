require "spec_helper"

describe Dwolla::Client do
  let!(:id) { "id" }
  let!(:secret) { "secret" }
  let!(:auth_url) { "auth_url" }
  let!(:token_url) { "token_url" }
  let!(:api_url) { "api_url" }

  it "::PRESETS" do
    expect(Dwolla::Client::PRESETS).to eq({
      :prod => {
        :auth_url  => "https://www.dwolla.com/authorize",
        :token_url => "https://www.dwolla.com/rest/token",
        :api_url   => "https://api.dwolla.com"
      },
      :sandbox => {
        :auth_url  => "https://uat.dwolla.com/authorize",
        :token_url => "https://uat.dwolla.com/rest/token",
        :api_url   => "https://api-uat.dwolla.com"
      }
    })
  end

  it "#initialize raises ArgumentError if no id" do
    expect {
      Dwolla::Client.new secret: secret
    }.to raise_error {|e|
      expect(e).to be_a ArgumentError
      expect(e.message).to eq "id is required"
    }
  end

  it "#initialize raises ArgumentError if no secret" do
    expect {
      Dwolla::Client.new id: id
    }.to raise_error {|e|
      expect(e).to be_a ArgumentError
      expect(e.message).to eq "secret is required"
    }
  end

  it "#initialize sets id" do
    client = Dwolla::Client.new id: id, secret: secret
    expect(client.id).to eq id
  end

  it "#initialize sets secret" do
    client = Dwolla::Client.new id: id, secret: secret
    expect(client.secret).to eq secret
  end

  it "#initialize sets auth_url" do
    client = Dwolla::Client.new id: id, secret: secret, auth_url: auth_url
    expect(client.auth_url).to eq auth_url
  end

  it "#initialize sets token_url" do
    client = Dwolla::Client.new id: id, secret: secret, token_url: token_url
    expect(client.token_url).to eq token_url
  end

  it "#initialize sets api_url" do
    client = Dwolla::Client.new id: id, secret: secret, api_url: api_url
    expect(client.api_url).to eq api_url
  end

  it "#initialize sets auth_url if none provided" do
    client = Dwolla::Client.new id: id, secret: secret
    expect(client.auth_url).to eq Dwolla::Client::PRESETS[:prod][:auth_url]
  end

  it "#initialize sets token_url if none provided" do
    client = Dwolla::Client.new id: id, secret: secret
    expect(client.token_url).to eq Dwolla::Client::PRESETS[:prod][:token_url]
  end

  it "#initialize sets api_url if none provided" do
    client = Dwolla::Client.new id: id, secret: secret
    expect(client.api_url).to eq Dwolla::Client::PRESETS[:prod][:api_url]
  end

  it "#id= raises ArgumentError" do
    client = Dwolla::Client.new id: id, secret: secret
    expect {
      client.id = nil
    }.to raise_error {|e|
      expect(e).to be_a ArgumentError
      expect(e.message).to eq "id must be a String"
    }
  end

  it "#secret= raises ArgumentError" do
    client = Dwolla::Client.new id: id, secret: secret
    expect {
      client.secret = nil
    }.to raise_error {|e|
      expect(e).to be_a ArgumentError
      expect(e.message).to eq "secret must be a String"
    }
  end

  it "#auth_url= raises ArgumentError" do
    client = Dwolla::Client.new id: id, secret: secret
    expect {
      client.auth_url = nil
    }.to raise_error {|e|
      expect(e).to be_a ArgumentError
      expect(e.message).to eq "auth_url must be a String"
    }
  end

  it "#token_url= raises ArgumentError" do
    client = Dwolla::Client.new id: id, secret: secret
    expect {
      client.token_url = nil
    }.to raise_error {|e|
      expect(e).to be_a ArgumentError
      expect(e.message).to eq "token_url must be a String"
    }
  end

  it "#api_url= raises ArgumentError" do
    client = Dwolla::Client.new id: id, secret: secret
    expect {
      client.api_url = nil
    }.to raise_error {|e|
      expect(e).to be_a ArgumentError
      expect(e.message).to eq "api_url must be a String"
    }
  end

  it "#configure" do
    client = Dwolla::Client.new id: id, secret: secret
    client.configure(:sandbox)
    expect(client.api_url).to eq Dwolla::Client::PRESETS[:sandbox][:api_url]
    expect(client.auth_url).to eq Dwolla::Client::PRESETS[:sandbox][:auth_url]
    expect(client.token_url).to eq Dwolla::Client::PRESETS[:sandbox][:token_url]
  end

  it "#configure raises ArgumentError" do
    client = Dwolla::Client.new id: id, secret: secret
    not_found_preset = :not_found
    expect {
      client.configure(not_found_preset)
    }.to raise_error {|e|
      expect(e).to be_a ArgumentError
      expect(e.message).to eq "#{not_found_preset} is not a valid config"
    }
  end

  it "#on_grant" do
    client = Dwolla::Client.new id: id, secret: secret
    expect(client.on_grant).to eq []
  end

  it "#on_grant(&block) adds callback" do
    client = Dwolla::Client.new id: id, secret: secret
    callback = Proc.new {}
    client.on_grant &callback
    expect(client.on_grant).to eq [callback]
  end

  it "#conn" do
    client = Dwolla::Client.new id: id, secret: secret
    expect(client.conn).to be_a Faraday::Connection
    expect(client.conn).to be client.conn
  end
end
