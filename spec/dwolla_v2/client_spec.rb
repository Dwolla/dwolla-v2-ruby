require "spec_helper"

describe DwollaV2::Client do
  let!(:id) { "id" }
  let!(:secret) { "secret" }

  it "::ENVIRONMENTS" do
    expect(DwollaV2::Client::ENVIRONMENTS).to eq({
      :production => {
        :auth_url  => "https://www.dwolla.com/oauth/v2/authenticate",
        :token_url => "https://www.dwolla.com/oauth/v2/token",
        :api_url   => "https://api.dwolla.com"
      },
      :sandbox => {
        :auth_url  => "https://sandbox.dwolla.com/oauth/v2/authenticate",
        :token_url => "https://sandbox.dwolla.com/oauth/v2/token",
        :api_url   => "https://api-sandbox.dwolla.com"
      }
    })
  end

  it "#initialize raises ArgumentError if no id" do
    expect {
      DwollaV2::Client.new :secret => secret
    }.to raise_error {|e|
      expect(e).to be_a ArgumentError
      expect(e.message).to eq ":key is required"
    }
  end

  it "#initialize raises ArgumentError if no secret" do
    expect {
      DwollaV2::Client.new :id => id
    }.to raise_error {|e|
      expect(e).to be_a ArgumentError
      expect(e.message).to eq ":secret is required"
    }
  end

  it "#initialize sets id" do
    client = DwollaV2::Client.new :id => id, :secret => secret
    expect(client.id).to eq id
  end

  it "#initialize sets id if key provided" do
    client = DwollaV2::Client.new :key => id, :secret => secret
    expect(client.id).to eq id
  end

  it "#initialize sets secret" do
    client = DwollaV2::Client.new :id => id, :secret => secret
    expect(client.secret).to eq secret
  end

  it "#initialize yields block" do
    james_bond = spy "007"
    block = Proc.new {|c| james_bond.call(c) }
    client = DwollaV2::Client.new :id => id, :secret => secret, &block
    expect(james_bond).to have_received(:call).with(client)
  end

  it '#initialize sets auths' do
    client = DwollaV2::Client.new :id => id, :secret => secret
    expect(client.auths).to be_a DwollaV2::Portal
    expect(client.auths.instance_variable_get :@parent).to be client
    expect(client.auths.instance_variable_get :@klass).to be DwollaV2::Auth
  end

  it '#initialize sets tokens' do
    client = DwollaV2::Client.new :id => id, :secret => secret
    expect(client.tokens).to be_a DwollaV2::Portal
    expect(client.tokens.instance_variable_get :@parent).to be client
    expect(client.tokens.instance_variable_get :@klass).to be DwollaV2::Token
  end

  it "#initialize freezes client" do
    client = DwollaV2::Client.new :id => id, :secret => secret
    expect(client.frozen?).to be true
  end

  it "#environment=" do
    client = DwollaV2::Client.new(:id => id, :secret => secret) {|c| c.environment = :sandbox }
    expect(client.environment).to eq :sandbox
  end

  it "#environment= accepts string" do
    client = DwollaV2::Client.new(:id => id, :secret => secret) {|c| c.environment = "sandbox" }
    expect(client.environment).to eq :sandbox
  end

  it "#environment= raises ArgumentError if invalid environment" do
    expect {
      DwollaV2::Client.new(:id => id, :secret => secret) {|c| c.environment = :invalid }
    }.to raise_error {|e|
      expect(e).to be_a ArgumentError
      expect(e.message).to eq "invalid environment"
    }
  end

  it "#environment with arg" do
    client = DwollaV2::Client.new(:id => id, :secret => secret) {|c| c.environment :sandbox }
    expect(client.environment).to eq :sandbox
  end

  it "#environment" do
    client = DwollaV2::Client.new :id => id, :secret => secret
    expect(client.environment).to eq :production
  end

  it "#on_grant with block" do
    callback = Proc.new {}
    client = DwollaV2::Client.new(:id => id, :secret => secret) {|c| c.on_grant &callback }
    expect(client.on_grant).to eq callback
  end

  it "#on_grant" do
    client = DwollaV2::Client.new :id => id, :secret => secret
    expect(client.on_grant).to be nil
  end

  it "#faraday with block" do
    block = Proc.new {}
    client = DwollaV2::Client.new(:id => id, :secret => secret) {|c| c.faraday &block }
    expect(client.faraday).to be block
  end

  it "#faraday" do
    client = DwollaV2::Client.new :id => id, :secret => secret
    expect(client.faraday).to be nil
  end

  it "#conn" do
    client = DwollaV2::Client.new :id => id, :secret => secret
    expect(client.conn).to be_a Faraday::Connection
    expect(client.conn).to be client.conn
  end

  it "#conn with faraday" do
    james_bond = spy "007"
    block = Proc.new {|a| james_bond.call(a) }
    client = DwollaV2::Client.new(:id => id, :secret => secret) {|c| c.faraday &block }
    expect(james_bond).to have_received(:call).with(client.conn)
  end

  it "#id" do
    client = DwollaV2::Client.new :id => id, :secret => secret
    expect(client.id).to be id
  end

  it "#key" do
    client = DwollaV2::Client.new :id => id, :secret => secret
    expect(client.key).to be id
  end

  it "#secret" do
    client = DwollaV2::Client.new :id => id, :secret => secret
    expect(client.secret).to be secret
  end

  it "#auth_url" do
    client = DwollaV2::Client.new :id => id, :secret => secret
    expect(client.auth_url).to eq DwollaV2::Client::ENVIRONMENTS[client.environment][:auth_url]
  end

  it "#token_url" do
    client = DwollaV2::Client.new :id => id, :secret => secret
    expect(client.token_url).to eq DwollaV2::Client::ENVIRONMENTS[client.environment][:token_url]
  end

  it "#api_url" do
    client = DwollaV2::Client.new :id => id, :secret => secret
    expect(client.api_url).to eq DwollaV2::Client::ENVIRONMENTS[client.environment][:api_url]
  end
end
