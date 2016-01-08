module Dwolla
  class Token
    extend Forwardable

    HTTP_METHODS = [:get, :post, :put, :patch, :delete]

    attr_reader :client, :access_token, :refresh_token, :expires_in, :scope, :account_id

    delegate [:in_parallel] => :@conn

    def initialize client, params
      @client = client
      @access_token = params[:access_token]
      @refresh_token = params[:refresh_token]
      @expires_in = params[:expires_in]
      @scope = params[:scope]
      @account_id = params[:account_id]
      conn
      freeze
    end

    def stringify_keys
      {
        "access_token"  => access_token,
        "refresh_token" => refresh_token,
        "expires_in"    => expires_in,
        "scope"         => scope,
        "account_id"    => account_id
      }.reject {|k,v| v.nil? }
    end

    HTTP_METHODS.each do |method|
      define_method(method) do |path, params = nil|
        full_url = self.class.full_url client, path
        res = conn.public_send method, full_url, params
        res_body = Util.deep_symbolize_keys res.body
        if res.status < 400
          res_body
        else
          Error.raise! res_body
        end
      end
    end

    private

    def conn
      @conn ||= Faraday.new do |f|
        f.authorization :Bearer, access_token if access_token
        f.headers["Accept"] = "application/vnd.dwolla.v1.hal+json"
        f.request :multipart
        f.request :json
        f.response :json, :content_type => /\bjson$/
        client.faraday.call(f) if client.faraday
        f.adapter Faraday.default_adapter unless client.faraday
      end
    end

    def self.full_url client, path
      path = path[:_links][:self][:href] if path.is_a? Hash
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
