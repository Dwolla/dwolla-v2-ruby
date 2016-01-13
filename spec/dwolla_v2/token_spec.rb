require "spec_helper"

describe DwollaV2::Token do
  let!(:client) { DwollaV2::Client.new :id => "CLIENT_ID", :secret => "CLIENT_SECRET" }
  let!(:params) {{
    :access_token  => "ACCESS_TOKEN",
    :refresh_token => "REFRESH_TOKEN",
    :expires_in    => 123,
    :scope         => "a,b,c",
    :app_id        => "9a711db1-72bc-43a4-8d09-3288e8dd0a8b",
    :account_id    => "92e19aa4-93d4-49e7-b3e6-32f6d7a2a64d",
    :unknown_param => "?"
  }}

  it "#initialize sets client" do
    token = DwollaV2::Token.new client, params
    expect(token.client).to be client
  end

  it "#initialize sets access_token" do
    token = DwollaV2::Token.new client, params
    expect(token.access_token).to eq params[:access_token]
  end

  it "#initialize sets refresh_token" do
    token = DwollaV2::Token.new client, params
    expect(token.refresh_token).to eq params[:refresh_token]
  end

  it "#initialize sets expires_in" do
    token = DwollaV2::Token.new client, params
    expect(token.expires_in).to eq params[:expires_in]
  end

  it "#initialize sets scope" do
    token = DwollaV2::Token.new client, params
    expect(token.scope).to eq params[:scope]
  end

  it "#initialize sets app_id" do
    token = DwollaV2::Token.new client, params
    expect(token.app_id).to eq params[:app_id]
  end

  it "#initialize sets account_id" do
    token = DwollaV2::Token.new client, params
    expect(token.account_id).to eq params[:account_id]
  end

  it "#initialize freezes token" do
    token = DwollaV2::Token.new client, params
    expect(token.frozen?).to be true
  end

  it "#[]" do
    token = DwollaV2::Token.new client, params
    expect(token[:access_token]).to be token.access_token
  end

  it "#stringify_keys" do
    token = DwollaV2::Token.new client, params
    expect(token.stringify_keys).to eq({
      "access_token"  => params[:access_token],
      "refresh_token" => params[:refresh_token],
      "expires_in"    => params[:expires_in],
      "scope"         => params[:scope],
      "app_id"        => params[:app_id],
      "account_id"    => params[:account_id]
    })
  end

  it "#stringify_keys rejects nil values" do
    token = DwollaV2::Token.new client, params.merge(:account_id => nil)
    expect(token.stringify_keys).to eq({
      "access_token"  => params[:access_token],
      "refresh_token" => params[:refresh_token],
      "expires_in"    => params[:expires_in],
      "scope"         => params[:scope],
      "app_id"        => params[:app_id]
    })
  end

  it "#in_parallel" do
    token = DwollaV2::Token.new client, params
    expect(token.instance_variable_get :@conn).to receive(:in_parallel)
    token.in_parallel
  end

  it "#get (success)" do
    token = DwollaV2::Token.new client, params
    path = "/foo"
    res_body = {:hello => "world"}
    stub_request(:get, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"})
      .to_return(:status => 200,
                 :headers => {"Content-Type" => "application/json"},
                 :body => JSON.generate(res_body))
    path_variants(path).each do |path_variant|
      expect(token.get path_variant).to eq res_body
    end
  end

  it "#get (error)" do
    token = DwollaV2::Token.new client, params
    path = "/foo"
    res_body = {:error => "hello"}
    stub_request(:get, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"})
      .to_return(:status => 400,
                 :headers => {"Content-Type" => "application/json"},
                 :body => JSON.generate(res_body))
    path_variants(path).each do |path_variant|
      expect {
        token.get path_variant
      }.to raise_error {|e|
        expect(e).to be_a DwollaV2::Error
        expect(e.error).to eq res_body[:error]
      }
    end
  end

  it "#get with params (success)" do
    token = DwollaV2::Token.new client, params
    path = "/foo"
    query = {:foo => "bar"}
    res_body = {:hello => "world"}
    stub_request(:get, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"},
            :query => query)
      .to_return(:status => 200,
                 :headers => {"Content-Type" => "application/json"},
                 :body => JSON.generate(res_body))
    path_variants(path).each do |path_variant|
      expect(token.get path, query).to eq res_body
    end
  end

  it "#get with params (error)" do
    token = DwollaV2::Token.new client, params
    path = "/foo"
    query = {:foo => "bar"}
    res_body = {:error => "hello"}
    stub_request(:get, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"},
            :query => query)
      .to_return(:status => 400,
                 :headers => {"Content-Type" => "application/json"},
                 :body => JSON.generate(res_body))
    path_variants(path).each do |path_variant|
      expect {
        token.get path_variant, query
      }.to raise_error {|e|
        expect(e).to be_a DwollaV2::Error
        expect(e.error).to eq res_body[:error]
      }
    end
  end

  it "#post (success)" do
    token = DwollaV2::Token.new client, params
    path = "/foo"
    res_body = {:hello => "world"}
    stub_request(:post, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"})
      .to_return(:status => 200,
                 :headers => {"Content-Type" => "application/json"},
                 :body => JSON.generate(res_body))
    path_variants(path).each do |path_variant|
      expect(token.post path_variant).to eq res_body
    end
  end

  it "#post (error)" do
    token = DwollaV2::Token.new client, params
    path = "/foo"
    res_body = {:error => "hello"}
    stub_request(:post, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"})
      .to_return(:status => 400,
                 :headers => {"Content-Type" => "application/json"},
                 :body => JSON.generate(res_body))
    path_variants(path).each do |path_variant|
      expect {
        token.post path_variant
      }.to raise_error {|e|
        expect(e).to be_a DwollaV2::Error
        expect(e.error).to eq res_body[:error]
      }
    end
  end

  it "#post with params (success)" do
    token = DwollaV2::Token.new client, params
    path = "/foo"
    body = {:foo => "bar"}
    res_body = {:hello => "world"}
    stub_request(:post, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json",
                         "Content-Type" => "application/json"},
            :body => body)
      .to_return(:status => 200,
                 :headers => {"Content-Type" => "application/json"},
                 :body => JSON.generate(res_body))
    path_variants(path).each do |path_variant|
      expect(token.post path_variant, body).to eq res_body
    end
  end

  it "#post with params (error)" do
    token = DwollaV2::Token.new client, params
    path = "/foo"
    body = {:foo => "bar"}
    res_body = {:error => "hello"}
    stub_request(:post, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json",
                         "Content-Type" => "application/json"},
            :body => body)
      .to_return(:status => 400,
                 :headers => {"Content-Type" => "application/json"},
                 :body => JSON.generate(res_body))
    path_variants(path).each do |path_variant|
      expect {
        token.post path_variant, body
      }.to raise_error {|e|
        expect(e).to be_a DwollaV2::Error
        expect(e.error).to eq res_body[:error]
      }
    end
  end

  it "#put (success)" do
    token = DwollaV2::Token.new client, params
    path = "/foo"
    res_body = {:hello => "world"}
    stub_request(:put, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"})
      .to_return(:status => 200,
                 :headers => {"Content-Type" => "application/json"},
                 :body => JSON.generate(res_body))
    path_variants(path).each do |path_variant|
      expect(token.put path_variant).to eq res_body
    end
  end

  it "#put (error)" do
    token = DwollaV2::Token.new client, params
    path = "/foo"
    res_body = {:error => "hello"}
    stub_request(:put, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"})
      .to_return(:status => 400,
                 :headers => {"Content-Type" => "application/json"},
                 :body => JSON.generate(res_body))
    path_variants(path).each do |path_variant|
      expect {
        token.put path_variant
      }.to raise_error {|e|
        expect(e).to be_a DwollaV2::Error
        expect(e.error).to eq res_body[:error]
      }
    end
  end

  it "#put with params (success)" do
    token = DwollaV2::Token.new client, params
    path = "/foo"
    body = {:foo => "bar"}
    res_body = {:hello => "world"}
    stub_request(:put, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json",
                         "Content-Type" => "application/json"},
            :body => body)
      .to_return(:status => 200,
                 :headers => {"Content-Type" => "application/json"},
                 :body => JSON.generate(res_body))
    path_variants(path).each do |path_variant|
      expect(token.put path_variant, body).to eq res_body
    end
  end

  it "#put with params (error)" do
    token = DwollaV2::Token.new client, params
    path = "/foo"
    body = {:foo => "bar"}
    res_body = {:error => "hello"}
    stub_request(:put, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json",
                         "Content-Type" => "application/json"},
            :body => body)
      .to_return(:status => 400,
                 :headers => {"Content-Type" => "application/json"},
                 :body => JSON.generate(res_body))
    path_variants(path).each do |path_variant|
      expect {
        token.put path, body
      }.to raise_error {|e|
        expect(e).to be_a DwollaV2::Error
        expect(e.error).to eq res_body[:error]
      }
    end
  end

  it "#patch (success)" do
    token = DwollaV2::Token.new client, params
    path = "/foo"
    res_body = {:hello => "world"}
    stub_request(:patch, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"})
      .to_return(:status => 200,
                 :headers => {"Content-Type" => "application/json"},
                 :body => JSON.generate(res_body))
    path_variants(path).each do |path_variant|
      expect(token.patch path).to eq res_body
    end
  end

  it "#patch (error)" do
    token = DwollaV2::Token.new client, params
    path = "/foo"
    res_body = {:error => "hello"}
    stub_request(:patch, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"})
      .to_return(:status => 400,
                 :headers => {"Content-Type" => "application/json"},
                 :body => JSON.generate(res_body))
    path_variants(path).each do |path_variant|
      expect {
        token.patch path
      }.to raise_error {|e|
        expect(e).to be_a DwollaV2::Error
        expect(e.error).to eq res_body[:error]
      }
    end
  end

  it "#patch with params (success)" do
    token = DwollaV2::Token.new client, params
    path = "/foo"
    body = {:foo => "bar"}
    res_body = {:hello => "world"}
    stub_request(:patch, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json",
                         "Content-Type" => "application/json"},
            :body => body)
      .to_return(:status => 200,
                 :headers => {"Content-Type" => "application/json"},
                 :body => JSON.generate(res_body))
    path_variants(path).each do |path_variant|
      expect(token.patch path_variant, body).to eq res_body
    end
  end

  it "#patch with params (error)" do
    token = DwollaV2::Token.new client, params
    path = "/foo"
    body = {:foo => "bar"}
    res_body = {:error => "hello"}
    stub_request(:patch, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json",
                         "Content-Type" => "application/json"},
            :body => body)
      .to_return(:status => 400,
                 :headers => {"Content-Type" => "application/json"},
                 :body => JSON.generate(res_body))
    path_variants(path).each do |path_variant|
      expect {
        token.patch path_variant, body
      }.to raise_error {|e|
        expect(e).to be_a DwollaV2::Error
        expect(e.error).to eq res_body[:error]
      }
    end
  end

  it "#delete (success)" do
    token = DwollaV2::Token.new client, params
    path = "/foo"
    res_body = {:hello => "world"}
    stub_request(:delete, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"})
      .to_return(:status => 200,
                 :headers => {"Content-Type" => "application/json"},
                 :body => JSON.generate(res_body))
    path_variants(path).each do |path_variant|
      expect(token.delete path_variant).to eq res_body
    end
  end

  it "#delete (error)" do
    token = DwollaV2::Token.new client, params
    path = "/foo"
    res_body = {:error => "hello"}
    stub_request(:delete, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"})
      .to_return(:status => 400,
                 :headers => {"Content-Type" => "application/json"},
                 :body => JSON.generate(res_body))
    path_variants(path).each do |path_variant|
      expect {
        token.delete path_variant
      }.to raise_error {|e|
        expect(e).to be_a DwollaV2::Error
        expect(e.error).to eq res_body[:error]
      }
    end
  end

  private

  def path_variants path
    [
      path,
      client.api_url + path,
      path[1..-1]
    ].map {|pv| [pv, {:_links => {:self => {:href => pv}}}] }.flatten
  end
end
