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

  it "#get (success)" do
    token = Dwolla::Token.new client, params
    path = "/foo"
    res_body = {:hello => "world"}
    stub_request(:get, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"})
      .to_return(:status => 200,
                 :headers => {"Content-Type" => "application/json"},
                 :body => JSON.generate(res_body))
    expect(token.get path).to eq res_body
  end

  it "#get (error)" do
    token = Dwolla::Token.new client, params
    path = "/foo"
    res_body = {:error => "hello"}
    stub_request(:get, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"})
      .to_return(:status => 400,
                 :headers => {"Content-Type" => "application/json"},
                 :body => JSON.generate(res_body))
    expect {
      token.get path
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::Error
      expect(e.error).to eq res_body[:error]
    }
  end

  it "#get with params (success)" do
    token = Dwolla::Token.new client, params
    path = "/foo"
    query = {:foo => "bar"}
    res_body = {:hello => "world"}
    stub_request(:get, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"},
            :query => query)
      .to_return(:status => 200,
                 :headers => {"Content-Type" => "application/json"},
                 :body => JSON.generate(res_body))
    expect(token.get path, query).to eq res_body
  end

  it "#get with params (error)" do
    token = Dwolla::Token.new client, params
    path = "/foo"
    query = {:foo => "bar"}
    res_body = {:error => "hello"}
    stub_request(:get, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"},
            :query => query)
      .to_return(:status => 400,
                 :headers => {"Content-Type" => "application/json"},
                 :body => JSON.generate(res_body))
    expect {
      token.get path, query
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::Error
      expect(e.error).to eq res_body[:error]
    }
  end

  it "#post (success)" do
    token = Dwolla::Token.new client, params
    path = "/foo"
    res_body = {:hello => "world"}
    stub_request(:post, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"})
      .to_return(:status => 200,
                 :headers => {"Content-Type" => "application/json"},
                 :body => JSON.generate(res_body))
    expect(token.post path).to eq res_body
  end

  it "#post (error)" do
    token = Dwolla::Token.new client, params
    path = "/foo"
    res_body = {:error => "hello"}
    stub_request(:post, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"})
      .to_return(:status => 400,
                 :headers => {"Content-Type" => "application/json"},
                 :body => JSON.generate(res_body))
    expect {
      token.post path
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::Error
      expect(e.error).to eq res_body[:error]
    }
  end

  it "#post with params (success)" do
    token = Dwolla::Token.new client, params
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
    expect(token.post path, body).to eq res_body
  end

  it "#post with params (error)" do
    token = Dwolla::Token.new client, params
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
    expect {
      token.post path, body
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::Error
      expect(e.error).to eq res_body[:error]
    }
  end

  it "#put (success)" do
    token = Dwolla::Token.new client, params
    path = "/foo"
    res_body = {:hello => "world"}
    stub_request(:put, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"})
      .to_return(:status => 200,
                 :headers => {"Content-Type" => "application/json"},
                 :body => JSON.generate(res_body))
    expect(token.put path).to eq res_body
  end

  it "#put (error)" do
    token = Dwolla::Token.new client, params
    path = "/foo"
    res_body = {:error => "hello"}
    stub_request(:put, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"})
      .to_return(:status => 400,
                 :headers => {"Content-Type" => "application/json"},
                 :body => JSON.generate(res_body))
    expect {
      token.put path
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::Error
      expect(e.error).to eq res_body[:error]
    }
  end

  it "#put with params (success)" do
    token = Dwolla::Token.new client, params
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
    expect(token.put path, body).to eq res_body
  end

  it "#put with params (error)" do
    token = Dwolla::Token.new client, params
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
    expect {
      token.put path, body
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::Error
      expect(e.error).to eq res_body[:error]
    }
  end

  it "#patch (success)" do
    token = Dwolla::Token.new client, params
    path = "/foo"
    res_body = {:hello => "world"}
    stub_request(:patch, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"})
      .to_return(:status => 200,
                 :headers => {"Content-Type" => "application/json"},
                 :body => JSON.generate(res_body))
    expect(token.patch path).to eq res_body
  end

  it "#patch (error)" do
    token = Dwolla::Token.new client, params
    path = "/foo"
    res_body = {:error => "hello"}
    stub_request(:patch, "#{token.client.api_url}#{path}")
      .with(:headers => {"Accept" => "application/vnd.dwolla.v1.hal+json"})
      .to_return(:status => 400,
                 :headers => {"Content-Type" => "application/json"},
                 :body => JSON.generate(res_body))
    expect {
      token.patch path
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::Error
      expect(e.error).to eq res_body[:error]
    }
  end

  it "#patch with params (success)" do
    token = Dwolla::Token.new client, params
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
    expect(token.patch path, body).to eq res_body
  end

  it "#patch with params (error)" do
    token = Dwolla::Token.new client, params
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
    expect {
      token.patch path, body
    }.to raise_error {|e|
      expect(e).to be_a Dwolla::Error
      expect(e.error).to eq res_body[:error]
    }
  end
end
