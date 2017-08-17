require "spec_helper"

describe DwollaV2::Token do
  let!(:client) { DwollaV2::Client.new :id => "CLIENT_ID", :secret => "CLIENT_SECRET" }
  let!(:hash_params) {{
    :access_token  => "ACCESS_TOKEN",
    :refresh_token => "REFRESH_TOKEN",
    :expires_in    => 123,
    :scope         => "a,b,c",
    :app_id        => "9a711db1-72bc-43a4-8d09-3288e8dd0a8b",
    :account_id    => "92e19aa4-93d4-49e7-b3e6-32f6d7a2a64d",
    :unknown_param => "?"
  }}
  let!(:method_params) {
    Class.new do
      def [](key);       raise "should use method not hash key :#{key}"; end
      def access_token;  "ACCESS_TOKEN"; end
      def refresh_token; "REFRESH_TOKEN"; end
      def expires_in;    123; end
      def scope;         "a,b,c"; end
      def app_id;        "9a711db1-72bc-43a4-8d09-3288e8dd0a8b"; end
      def account_id;    "92e19aa4-93d4-49e7-b3e6-32f6d7a2a64d"; end
      def unknown_param; "?"; end
    end.new
  }
  let!(:headers) {{
    :foo => 'bar'
  }}

  it "#initialize sets client" do
    token = DwollaV2::Token.new client, hash_params
    expect(token.client).to be client
  end

  it "#initialize sets access_token (hash params)" do
    token = DwollaV2::Token.new client, hash_params
    expect(token.access_token).to eq hash_params[:access_token]
  end

  it "#initialize sets access_token (method params)" do
    token = DwollaV2::Token.new client, method_params
    expect(token.access_token).to eq method_params.access_token
  end

  it "#initialize sets refresh_token (hash params)" do
    token = DwollaV2::Token.new client, hash_params
    expect(token.refresh_token).to eq hash_params[:refresh_token]
  end

  it "#initialize sets refresh_token (method params)" do
    token = DwollaV2::Token.new client, method_params
    expect(token.refresh_token).to eq method_params.refresh_token
  end

  it "#initialize sets expires_in (hash params)" do
    token = DwollaV2::Token.new client, hash_params
    expect(token.expires_in).to eq hash_params[:expires_in]
  end

  it "#initialize sets expires_in (method params)" do
    token = DwollaV2::Token.new client, method_params
    expect(token.expires_in).to eq method_params.expires_in
  end

  it "#initialize sets scope (hash params)" do
    token = DwollaV2::Token.new client, hash_params
    expect(token.scope).to eq hash_params[:scope]
  end

  it "#initialize sets scope (method params)" do
    token = DwollaV2::Token.new client, method_params
    expect(token.scope).to eq method_params.scope
  end

  it "#initialize sets app_id (hash params)" do
    token = DwollaV2::Token.new client, hash_params
    expect(token.app_id).to eq hash_params[:app_id]
  end

  it "#initialize sets app_id (method params)" do
    token = DwollaV2::Token.new client, method_params
    expect(token.app_id).to eq method_params.app_id
  end

  it "#initialize sets account_id (hash params)" do
    token = DwollaV2::Token.new client, hash_params
    expect(token.account_id).to eq hash_params[:account_id]
  end

  it "#initialize sets account_id (method params)" do
    token = DwollaV2::Token.new client, method_params
    expect(token.account_id).to eq method_params.account_id
  end

  it "#initialize freezes token" do
    token = DwollaV2::Token.new client, hash_params
    expect(token.frozen?).to be true
  end

  it "#[]" do
    token = DwollaV2::Token.new client, hash_params
    expect(token[:access_token]).to be token.access_token
  end

  it "#stringify_keys" do
    token = DwollaV2::Token.new client, hash_params
    expect(token.stringify_keys).to eq({
      "access_token"  => hash_params[:access_token],
      "refresh_token" => hash_params[:refresh_token],
      "expires_in"    => hash_params[:expires_in],
      "scope"         => hash_params[:scope],
      "app_id"        => hash_params[:app_id],
      "account_id"    => hash_params[:account_id]
    })
  end

  it "#stringify_keys rejects nil values" do
    token = DwollaV2::Token.new client, hash_params.merge(:account_id => nil)
    expect(token.stringify_keys).to eq({
      "access_token"  => hash_params[:access_token],
      "refresh_token" => hash_params[:refresh_token],
      "expires_in"    => hash_params[:expires_in],
      "scope"         => hash_params[:scope],
      "app_id"        => hash_params[:app_id]
    })
  end

  it "#empty? forwards to stringify_keys" do
    token = DwollaV2::Token.new client, {}
    expect(token.empty?).to be true
  end

  it "#empty? forwards to stringify_keys" do
    token = DwollaV2::Token.new client, hash_params
    expect(token.empty?).to be false
  end

  it "#reject gets forwarded to #stringify_keys" do
    token = DwollaV2::Token.new client, hash_params
    expect(
      token.reject {|_,_| false }
    ).to eq(
      token.stringify_keys.reject {|_,_| false }
    )
  end

  it "#in_parallel" do
    token = DwollaV2::Token.new client, hash_params
    expect(token.instance_variable_get :@conn).to receive(:in_parallel)
    token.in_parallel
  end

  it "#get (success)" do
    token = DwollaV2::Token.new client, hash_params
    path = "/foo"
    res_body = {:hello => "world", :timestamp => Time.now.utc.round(3)}
    stub_request(:get, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"})
      .to_return(:status => 200,
                 :headers => {"Content-Type" => "application/json"},
                 :body => generate_json(res_body))
    path_variants(path).each do |path_variant|
      expect(token.get path_variant).to eq res_body
    end
  end

  it "#get (error)" do
    token = DwollaV2::Token.new client, hash_params
    path = "/foo"
    res_body = {:error => "hello"}
    stub_request(:get, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"})
      .to_return(:status => 400,
                 :headers => {"Content-Type" => "application/json"},
                 :body => generate_json(res_body))
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
    token = DwollaV2::Token.new client, hash_params
    path = "/foo"
    query = {:foo => "bar"}
    res_body = {:hello => "world", :timestamp => Time.now.utc.round(3)}
    stub_request(:get, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"},
            :query => query)
      .to_return(:status => 200,
                 :headers => {"Content-Type" => "application/json"},
                 :body => generate_json(res_body))
    path_variants(path).each do |path_variant|
      expect(token.get path, query).to eq res_body
    end
  end

  it "#get with params (error)" do
    token = DwollaV2::Token.new client, hash_params
    path = "/foo"
    query = {:foo => "bar"}
    res_body = {:error => "hello"}
    stub_request(:get, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"},
            :query => query)
      .to_return(:status => 400,
                 :headers => {"Content-Type" => "application/json"},
                 :body => generate_json(res_body))
    path_variants(path).each do |path_variant|
      expect {
        token.get path_variant, query
      }.to raise_error {|e|
        expect(e).to be_a DwollaV2::Error
        expect(e.error).to eq res_body[:error]
      }
    end
  end

  it "#get with headers (success)" do
    token = DwollaV2::Token.new client, hash_params
    path = "/foo"
    query = {:foo => "bar"}
    res_body = {:hello => "world", :timestamp => Time.now.utc.round(3)}
    stub_request(:get, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"}.merge(headers),
            :query => query)
      .to_return(:status => 200,
                 :headers => {"Content-Type" => "application/json"},
                 :body => generate_json(res_body))
    path_variants(path).each do |path_variant|
      expect(token.get path, query, headers).to eq res_body
    end
  end

  it "#get with headers (error)" do
    token = DwollaV2::Token.new client, hash_params
    path = "/foo"
    query = {:foo => "bar"}
    res_body = {:error => "hello"}
    stub_request(:get, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"}.merge(headers),
            :query => query)
      .to_return(:status => 400,
                 :headers => {"Content-Type" => "application/json"},
                 :body => generate_json(res_body))
    path_variants(path).each do |path_variant|
      expect {
        token.get path_variant, query, headers
      }.to raise_error {|e|
        expect(e).to be_a DwollaV2::Error
        expect(e.error).to eq res_body[:error]
      }
    end
  end

  it "#post (success)" do
    token = DwollaV2::Token.new client, hash_params
    path = "/foo"
    res_body = {:hello => "world", :timestamp => Time.now.utc.round(3)}
    stub_request(:post, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"})
      .to_return(:status => 200,
                 :headers => {"Content-Type" => "application/json"},
                 :body => generate_json(res_body))
    path_variants(path).each do |path_variant|
      expect(token.post path_variant).to eq res_body
    end
  end

  it "#post (do not mutate path)" do
    token = DwollaV2::Token.new client, hash_params
    path = "/foo"
    res_body = {:hello => "world", :timestamp => Time.now.utc.round(3)}
    stub_request(:post, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"})
      .to_return(:status => 200,
                 :headers => {"Content-Type" => "application/json"},
                 :body => generate_json(res_body))
    path_variants(path).each do |path_variant|
      path_variant_copy = path_variant.clone
      expect(token.post path_variant).to eq res_body
      expect(path_variant).to eq path_variant_copy
    end
  end

  it "#post (error)" do
    token = DwollaV2::Token.new client, hash_params
    path = "/foo"
    res_body = {:error => "hello"}
    stub_request(:post, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"})
      .to_return(:status => 400,
                 :headers => {"Content-Type" => "application/json"},
                 :body => generate_json(res_body))
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
    token = DwollaV2::Token.new client, hash_params
    path = "/foo"
    body = {:foo => "bar"}
    res_body = {:hello => "world", :timestamp => Time.now.utc.round(3)}
    stub_request(:post, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json",
                         "Content-Type" => "application/json"},
            :body => body)
      .to_return(:status => 200,
                 :headers => {"Content-Type" => "application/json"},
                 :body => generate_json(res_body))
    path_variants(path).each do |path_variant|
      expect(token.post path_variant, body).to eq res_body
    end
  end

  it "#post with params (error)" do
    token = DwollaV2::Token.new client, hash_params
    path = "/foo"
    body = {:foo => "bar"}
    res_body = {:error => "hello"}
    stub_request(:post, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json",
                         "Content-Type" => "application/json"},
            :body => body)
      .to_return(:status => 400,
                 :headers => {"Content-Type" => "application/json"},
                 :body => generate_json(res_body))
    path_variants(path).each do |path_variant|
      expect {
        token.post path_variant, body
      }.to raise_error {|e|
        expect(e).to be_a DwollaV2::Error
        expect(e.error).to eq res_body[:error]
      }
    end
  end

  it "#post with headers (success)" do
    token = DwollaV2::Token.new client, hash_params
    path = "/foo"
    res_body = {:hello => "world", :timestamp => Time.now.utc.round(3)}
    stub_request(:post, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"}.merge(headers))
      .to_return(:status => 200,
                 :headers => {"Content-Type" => "application/json"},
                 :body => generate_json(res_body))
    path_variants(path).each do |path_variant|
      expect(token.post path_variant, nil, headers).to eq res_body
    end
  end

  it "#post with headers (error)" do
    token = DwollaV2::Token.new client, hash_params
    path = "/foo"
    body = {:foo => "bar"}
    res_body = {:error => "hello"}
    stub_request(:post, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json",
                         "Content-Type" => "application/json"}.merge(headers),
            :body => body)
      .to_return(:status => 400,
                 :headers => {"Content-Type" => "application/json"},
                 :body => generate_json(res_body))
    path_variants(path).each do |path_variant|
      expect {
        token.post path_variant, body, headers
      }.to raise_error {|e|
        expect(e).to be_a DwollaV2::Error
        expect(e.error).to eq res_body[:error]
      }
    end
  end

  it "#put (success)" do
    token = DwollaV2::Token.new client, hash_params
    path = "/foo"
    res_body = {:hello => "world", :timestamp => Time.now.utc.round(3)}
    stub_request(:put, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"})
      .to_return(:status => 200,
                 :headers => {"Content-Type" => "application/json"},
                 :body => generate_json(res_body))
    path_variants(path).each do |path_variant|
      expect(token.put path_variant).to eq res_body
    end
  end

  it "#put (error)" do
    token = DwollaV2::Token.new client, hash_params
    path = "/foo"
    res_body = {:error => "hello"}
    stub_request(:put, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"})
      .to_return(:status => 400,
                 :headers => {"Content-Type" => "application/json"},
                 :body => generate_json(res_body))
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
    token = DwollaV2::Token.new client, hash_params
    path = "/foo"
    body = {:foo => "bar"}
    res_body = {:hello => "world", :timestamp => Time.now.utc.round(3)}
    stub_request(:put, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json",
                         "Content-Type" => "application/json"},
            :body => body)
      .to_return(:status => 200,
                 :headers => {"Content-Type" => "application/json"},
                 :body => generate_json(res_body))
    path_variants(path).each do |path_variant|
      expect(token.put path_variant, body).to eq res_body
    end
  end

  it "#put with params (error)" do
    token = DwollaV2::Token.new client, hash_params
    path = "/foo"
    body = {:foo => "bar"}
    res_body = {:error => "hello"}
    stub_request(:put, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json",
                         "Content-Type" => "application/json"},
            :body => body)
      .to_return(:status => 400,
                 :headers => {"Content-Type" => "application/json"},
                 :body => generate_json(res_body))
    path_variants(path).each do |path_variant|
      expect {
        token.put path, body
      }.to raise_error {|e|
        expect(e).to be_a DwollaV2::Error
        expect(e.error).to eq res_body[:error]
      }
    end
  end

  it "#put with headers (success)" do
    token = DwollaV2::Token.new client, hash_params
    path = "/foo"
    res_body = {:hello => "world", :timestamp => Time.now.utc.round(3)}
    stub_request(:put, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"}.merge(headers))
      .to_return(:status => 200,
                 :headers => {"Content-Type" => "application/json"},
                 :body => generate_json(res_body))
    path_variants(path).each do |path_variant|
      expect(token.put path_variant, nil, headers).to eq res_body
    end
  end

  it "#put with headers (error)" do
    token = DwollaV2::Token.new client, hash_params
    path = "/foo"
    body = {:foo => "bar"}
    res_body = {:error => "hello"}
    stub_request(:put, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json",
                         "Content-Type" => "application/json"}.merge(headers),
            :body => body)
      .to_return(:status => 400,
                 :headers => {"Content-Type" => "application/json"},
                 :body => generate_json(res_body))
    path_variants(path).each do |path_variant|
      expect {
        token.put path_variant, body, headers
      }.to raise_error {|e|
        expect(e).to be_a DwollaV2::Error
        expect(e.error).to eq res_body[:error]
      }
    end
  end

  it "#patch (success)" do
    token = DwollaV2::Token.new client, hash_params
    path = "/foo"
    res_body = {:hello => "world", :timestamp => Time.now.utc.round(3)}
    stub_request(:patch, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"})
      .to_return(:status => 200,
                 :headers => {"Content-Type" => "application/json"},
                 :body => generate_json(res_body))
    path_variants(path).each do |path_variant|
      expect(token.patch path).to eq res_body
    end
  end

  it "#patch (error)" do
    token = DwollaV2::Token.new client, hash_params
    path = "/foo"
    res_body = {:error => "hello"}
    stub_request(:patch, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"})
      .to_return(:status => 400,
                 :headers => {"Content-Type" => "application/json"},
                 :body => generate_json(res_body))
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
    token = DwollaV2::Token.new client, hash_params
    path = "/foo"
    body = {:foo => "bar"}
    res_body = {:hello => "world", :timestamp => Time.now.utc.round(3)}
    stub_request(:patch, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json",
                         "Content-Type" => "application/json"},
            :body => body)
      .to_return(:status => 200,
                 :headers => {"Content-Type" => "application/json"},
                 :body => generate_json(res_body))
    path_variants(path).each do |path_variant|
      expect(token.patch path_variant, body).to eq res_body
    end
  end

  it "#patch with params (error)" do
    token = DwollaV2::Token.new client, hash_params
    path = "/foo"
    body = {:foo => "bar"}
    res_body = {:error => "hello"}
    stub_request(:patch, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json",
                         "Content-Type" => "application/json"},
            :body => body)
      .to_return(:status => 400,
                 :headers => {"Content-Type" => "application/json"},
                 :body => generate_json(res_body))
    path_variants(path).each do |path_variant|
      expect {
        token.patch path_variant, body
      }.to raise_error {|e|
        expect(e).to be_a DwollaV2::Error
        expect(e.error).to eq res_body[:error]
      }
    end
  end

  it "#patch with headers (success)" do
    token = DwollaV2::Token.new client, hash_params
    path = "/foo"
    res_body = {:hello => "world", :timestamp => Time.now.utc.round(3)}
    stub_request(:patch, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"}.merge(headers))
      .to_return(:status => 200,
                 :headers => {"Content-Type" => "application/json"},
                 :body => generate_json(res_body))
    path_variants(path).each do |path_variant|
      expect(token.patch path_variant, nil, headers).to eq res_body
    end
  end

  it "#patch with headers (error)" do
    token = DwollaV2::Token.new client, hash_params
    path = "/foo"
    body = {:foo => "bar"}
    res_body = {:error => "hello"}
    stub_request(:patch, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json",
                         "Content-Type" => "application/json"}.merge(headers),
            :body => body)
      .to_return(:status => 400,
                 :headers => {"Content-Type" => "application/json"},
                 :body => generate_json(res_body))
    path_variants(path).each do |path_variant|
      expect {
        token.patch path_variant, body, headers
      }.to raise_error {|e|
        expect(e).to be_a DwollaV2::Error
        expect(e.error).to eq res_body[:error]
      }
    end
  end

  it "#delete (success)" do
    token = DwollaV2::Token.new client, hash_params
    path = "/foo"
    res_body = {:hello => "world", :timestamp => Time.now.utc.round(3)}
    stub_request(:delete, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"})
      .to_return(:status => 200,
                 :headers => {"Content-Type" => "application/json"},
                 :body => generate_json(res_body))
    path_variants(path).each do |path_variant|
      expect(token.delete path_variant).to eq res_body
    end
  end

  it "#delete (error)" do
    token = DwollaV2::Token.new client, hash_params
    path = "/foo"
    res_body = {:error => "hello"}
    stub_request(:delete, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"})
      .to_return(:status => 400,
                 :headers => {"Content-Type" => "application/json"},
                 :body => generate_json(res_body))
    path_variants(path).each do |path_variant|
      expect {
        token.delete path_variant
      }.to raise_error {|e|
        expect(e).to be_a DwollaV2::Error
        expect(e.error).to eq res_body[:error]
      }
    end
  end

  it "#delete with headers (success)" do
    token = DwollaV2::Token.new client, hash_params
    path = "/foo"
    res_body = {:hello => "world", :timestamp => Time.now.utc.round(3)}
    stub_request(:delete, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"}.merge(headers))
      .to_return(:status => 200,
                 :headers => {"Content-Type" => "application/json"},
                 :body => generate_json(res_body))
    path_variants(path).each do |path_variant|
      expect(token.delete path_variant, nil, headers).to eq res_body
    end
  end

  it "#delete with headers (error)" do
    token = DwollaV2::Token.new client, hash_params
    path = "/foo"
    res_body = {:error => "hello"}
    stub_request(:delete, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"}.merge(headers))
      .to_return(:status => 400,
                 :headers => {"Content-Type" => "application/json"},
                 :body => generate_json(res_body))
    path_variants(path).each do |path_variant|
      expect {
        token.delete path_variant, nil, headers
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
      "https://foo-bar.com#{path}",
      "#{client.api_url}#{path}",
      path[1..-1]
    ].map {|pv| [pv, {:_links => {:self => {:href => pv}}}] }.flatten
  end

  def generate_json obj
    JSON.generate obj.inject({}) { |h, (k, v)| h[k] = v.is_a?(Time) ? v.iso8601(3) : v; h }
  end
end
