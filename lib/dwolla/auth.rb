module Dwolla
  class Auth
    attr_reader :client, :redirect_uri, :scope, :state

    def self.client client, params = {}
      request_token client, {:grant_type => "client_credentials"}.merge(params)
    end

    def self.refresh client, token, params = {}
      raise ArgumentError.new "Dwolla::Token required" unless token.is_a? Token
      raise ArgumentError.new "invalid refresh_token" unless token.refresh_token.is_a? String
      request_token client, {:grant_type => "refresh_token", :refresh_token => token.refresh_token}.merge(params)
    end

    def initialize client, params = {}
      @client = client
      @redirect_uri = params[:redirect_uri]
      @scope = params[:scope]
      @state = params[:state]
      freeze
    end

    def url
      "#{client.auth_url}?#{URI.encode_www_form(query)}"
    end

    def callback params
      raise ArgumentError.new "state does not match" if params[:state] != state
      raise ArgumentError.new "code is required" unless params[:code].is_a? String
      params = {:code => params[:code], :redirect_uri => redirect_uri}.reject {|k,v| v.nil? }
      self.class.request_token client, {:grant_type => "authorization_code"}.merge(params)
    end

    private

    def query
      {
        :redirect_uri => redirect_uri,
        :scope => scope,
        :state => state
      }.reject {|k,v| v.nil? }
    end

    def self.request_token client, params
      res = client.conn.post client.token_url, params
      res_body = Util.parse_json res.body
      if res.status == 200
        Token.new client, res_body
      else
        Error.raise! res_body
      end
    end
  end
end
