require "spec_helper"

describe Dwolla::Client do
  let!(:id) { "id" }
  let!(:secret) { "secret" }

  it "::ENVIRONMENTS" do
    expect(Dwolla::Client::ENVIRONMENTS).to eq({
      :default => {
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
      Dwolla::Client.new :secret => secret
    }.to raise_error {|e|
      expect(e).to be_a ArgumentError
      expect(e.message).to eq "id is required"
    }
  end

  it "#initialize raises ArgumentError if no secret" do
    expect {
      Dwolla::Client.new :id => id
    }.to raise_error {|e|
      expect(e).to be_a ArgumentError
      expect(e.message).to eq "secret is required"
    }
  end

  it "#initialize sets id" do
    client = Dwolla::Client.new :id => id, :secret => secret
    expect(client.id).to eq id
  end

  it "#initialize sets secret" do
    client = Dwolla::Client.new :id => id, :secret => secret
    expect(client.secret).to eq secret
  end

  it "#initialize yields block" do
    james_bond = spy "007"
    block = Proc.new {|c| james_bond.call(c) }
    client = Dwolla::Client.new :id => id, :secret => secret, &block
    expect(james_bond).to have_received(:call).with(client)
  end

  it "#initialize freezes client" do
    client = Dwolla::Client.new :id => id, :secret => secret
    expect(client.frozen?).to be true
  end

  it "#environment=" do
    client = Dwolla::Client.new(:id => id, :secret => secret) {|c| c.environment = :sandbox }
    expect(client.environment).to eq :sandbox
  end

  it "#environment= raises ArgumentError if invalid environment" do
    expect {
      Dwolla::Client.new(:id => id, :secret => secret) {|c| c.environment = :invalid }
    }.to raise_error {|e|
      expect(e).to be_a ArgumentError
      expect(e.message).to eq "invalid environment"
    }
  end

  it "#environment" do
    client = Dwolla::Client.new :id => id, :secret => secret
    expect(client.environment).to eq :default
  end

  it "#on_grant with block" do
    callback = Proc.new {}
    client = Dwolla::Client.new(:id => id, :secret => secret) {|c| c.on_grant &callback }
    expect(client.on_grant).to eq callback
  end

  it "#on_grant" do
    client = Dwolla::Client.new :id => id, :secret => secret
    expect(client.on_grant).to be nil
  end

  it "#conn with block" do
    james_bond = spy "007"
    block = Proc.new {|c| james_bond.call(c) }
    client = Dwolla::Client.new(:id => id, :secret => secret) {|c| c.conn &block }
    expect(james_bond).to have_received(:call).with(client.conn)
  end

  it "#conn" do
    client = Dwolla::Client.new :id => id, :secret => secret
    expect(client.conn).to be_a Faraday::Connection
    expect(client.conn).to be client.conn
  end

  it "#auth_url" do
    client = Dwolla::Client.new :id => id, :secret => secret
    expect(client.auth_url).to eq Dwolla::Client::ENVIRONMENTS[client.environment][:auth_url]
  end

  it "#token_url" do
    client = Dwolla::Client.new :id => id, :secret => secret
    expect(client.token_url).to eq Dwolla::Client::ENVIRONMENTS[client.environment][:token_url]
  end

  it "#api_url" do
    client = Dwolla::Client.new :id => id, :secret => secret
    expect(client.api_url).to eq Dwolla::Client::ENVIRONMENTS[client.environment][:api_url]
  end
end
