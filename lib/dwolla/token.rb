module Dwolla
  class Token
    attr_reader :client, :access_token, :refresh_token, :expires_in, :scope, :account_id

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
  end
end
