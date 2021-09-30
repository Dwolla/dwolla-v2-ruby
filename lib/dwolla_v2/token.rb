module DwollaV2
  class Token
    extend Forwardable

    HTTP_METHODS = [:get, :post, :put, :patch, :delete]

    attr_reader :client, :access_token, :refresh_token, :expires_in, :scope, :app_id, :account_id

    delegate [:in_parallel] => :@conn
    delegate [:reject, :empty?] => :stringify_keys

    def initialize client, params
      @client = client
      @access_token  = get_param params, :access_token
      @refresh_token = get_param params, :refresh_token
      @expires_in    = get_param params, :expires_in
      @scope         = get_param params, :scope
      @app_id        = get_param params, :app_id
      @account_id    = get_param params, :account_id
      conn
      freeze
    end

    def [] key
      instance_variable_get :"@#{key}"
    end

    def stringify_keys
      {
        "access_token"  => access_token,
        "refresh_token" => refresh_token,
        "expires_in"    => expires_in,
        "scope"         => scope,
        "app_id"        => app_id,
        "account_id"    => account_id
      }.reject {|k,v| v.nil? }
    end

    HTTP_METHODS.each do |method|
      define_method(method) do |path, params = nil, headers = nil|
        full_url = self.class.full_url client, path
        Response.new conn.public_send(method, full_url, params, headers)
      end
    end

    def inspect
      Util.pretty_inspect self.class.name,
        client: client, access_token: access_token, refresh_token: refresh_token,
        expires_in: expires_in, scope: scope, app_id: app_id, account_id: account_id
    end

    private

    def conn
      @conn ||= Faraday.new do |f|
        f.request :authorization, :Bearer, access_token if access_token
        f.headers[:accept] = "application/vnd.dwolla.v1.hal+json"
        f.request :multipart
        f.request :json
        f.use SetUserAgent
        f.use HandleErrors
        f.use DeepSuperHasherizeResponseBody
        f.use DeepParseIso8601ResponseBody
        f.response :json, :content_type => /\bjson$/
        client.faraday.call(f) if client.faraday
        f.adapter Faraday.default_adapter unless client.faraday
      end
    end

    def get_param params, key
      if params.respond_to? key
        params.public_send key
      else
        params[key]
      end
    end

    def self.full_url client, path
      path = path[:_links][:self][:href] if path.is_a? Hash
      path = path.sub /^https?:\/\/[^\/]*/, ""
      if path.start_with? client.api_url
        path
      elsif path.start_with? "/"
        client.api_url + path
      else
        "#{client.api_url}/#{path}"
      end
    end
  end
end
