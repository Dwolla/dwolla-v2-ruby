module DwollaV2
  class Token
    extend Forwardable

    EXPIRES_IN_LEEWAY = 60
    HTTP_METHODS = [:get, :post, :put, :patch, :delete]

    attr_reader :client, :access_token, :refresh_token, :expires_at,
      :expires_in, :refresh_expires_at, :refresh_expires_in, :scope, :app_id,
      :account_id

    delegate [:in_parallel] => :@conn
    delegate [:reject, :empty?] => :stringify_keys

    def initialize client, params
      t = Time.now.utc
      # symbolize keys for hash params
      if params.respond_to?(:keys)
        params = params.inject({}){|x,(k,v)| x[k.to_sym] = v; x}
      end
      @client = client
      @access_token       = get_param params, :access_token
      @refresh_token      = get_param params, :refresh_token
      @expires_in         = get_param params, :expires_in
      @expires_at         = get_param params, :expires_at
      @refresh_expires_in = get_param params, :refresh_expires_in
      @refresh_expires_at = get_param params, :refresh_expires_at
      @scope              = get_param params, :scope
      @app_id             = get_param params, :app_id
      @account_id         = get_param params, :account_id

      # Convert string expires_at values to Time
      if @expires_at && @expires_at.is_a?(String)
        @expires_at = Time.iso8601(@expires_at)
      end
      if @refresh_expires_at && @refresh_expires_at.is_a?(String)
        @refresh_expires_at = Time.iso8601(@refresh_expires_at)
      end

      # If expires_at not provided, calculate it based on current time
      if !@expires_at && @expires_in
        @expires_at = t + @expires_in
      end
      if !@refresh_expires_at && @refresh_expires_in
        @refresh_expires_at = t + @refresh_expires_in
      end
    end

    def is_expired?
      @expires_at && (@expires_at - EXPIRES_IN_LEEWAY < Time.now.utc)
    end

    def is_refresh_expired?
      @refresh_expires_at && (@refresh_expires_at - EXPIRES_IN_LEEWAY < Time.now.utc)
    end

    def [] key
      instance_variable_get :"@#{key}"
    end

    def stringify_keys
      as_json.reject {|k,v| v.nil? }
    end

    def as_json
      {
        "access_token"       => access_token,
        "refresh_token"      => refresh_token,
        "expires_in"         => expires_in,
        "expires_at"         => expires_at,
        "refresh_expires_in" => refresh_expires_in,
        "refresh_expires_at" => refresh_expires_at,
        "scope"              => scope,
        "app_id"             => app_id,
        "account_id"         => account_id,
      }
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
        f.authorization :Bearer, access_token if access_token
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
