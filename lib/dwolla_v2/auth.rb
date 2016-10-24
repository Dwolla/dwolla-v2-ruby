module DwollaV2
  class Auth
    attr_reader :client, :redirect_uri, :scope, :state, :verified_account, :dwolla_landing

    def self.client client, params = {}
      request_token client, {:grant_type => :client_credentials}.merge(params)
    end

    def self.refresh client, token, params = {}
      refresh_token = token.respond_to?(:refresh_token) ? token.refresh_token : token[:refresh_token]
      raise ArgumentError.new "invalid refresh_token" unless refresh_token.is_a? String
      request_token client, {:grant_type => :refresh_token, :refresh_token => refresh_token}.merge(params)
    end

    def initialize client, params = {}
      @client = client
      @redirect_uri = params[:redirect_uri]
      @scope = params[:scope]
      @state = params[:state]
      @verified_account = params[:verified_account]
      @dwolla_landing = params[:dwolla_landing]
      freeze
    end

    def url
      "#{client.auth_url}?#{URI.encode_www_form(query)}"
    end

    def callback params
      raise ArgumentError.new "state does not match" if params[:state] != state
      Error.raise! params if params[:error]
      raise ArgumentError.new "code is required" unless params[:code].is_a? String
      params = {:code => params[:code], :redirect_uri => redirect_uri}.reject {|k,v| v.nil? }
      self.class.request_token client, {:grant_type => :authorization_code}.merge(params)
    end

    private

    def query
      {
        :response_type => :code,
        :client_id => client.id,
        :redirect_uri => redirect_uri,
        :scope => scope,
        :state => state,
        :verified_account => verified_account,
        :dwolla_landing => dwolla_landing
      }.reject {|k,v| v.nil? }
    end

    def self.request_token client, params
      res = client.conn.post client.token_url, params
      if !res.body.is_a?(Hash) || res.body.has_key?(:error)
        Error.raise! res
      else
        token = Token.new client, res.body
        client.on_grant.call token unless client.on_grant.nil?
        token
      end
    end
  end
end
