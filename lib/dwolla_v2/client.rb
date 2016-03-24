module DwollaV2
  class Client
    ENVIRONMENTS = {
      :default => {
        :auth_url  => "https://www.dwolla.com/oauth/v2/authenticate",
        :token_url => "https://www.dwolla.com/oauth/v2/token",
        :api_url   => "https://api.dwolla.com"
      },
      :sandbox => {
        :auth_url  => "https://uat.dwolla.com/oauth/v2/authenticate",
        :token_url => "https://uat.dwolla.com/oauth/v2/token",
        :api_url   => "https://api-uat.dwolla.com"
      }
    }

    attr_reader :id, :secret, :auths, :tokens

    def initialize opts
      raise ArgumentError.new "id is required" unless opts[:id].is_a? String
      raise ArgumentError.new "secret is required" unless opts[:secret].is_a? String
      @id = opts[:id]
      @secret = opts[:secret]
      yield self if block_given?
      conn
      @auths = Portal.new self, Auth
      @tokens = Portal.new self, Token
      freeze
    end

    def environment= env
      env = :"#{env}"
      raise ArgumentError.new "invalid environment" unless ENVIRONMENTS.has_key? env
      @environment = env
    end

    def environment env = nil
      self.environment = env unless env.nil?
      @environment || :default
    end

    def on_grant &callback
      @on_grant = callback if callback
      @on_grant
    end

    def faraday &block
      @faraday = block if block
      @faraday
    end

    def conn
      @conn ||= Faraday.new do |f|
        f.request :basic_auth, id, secret
        f.request :url_encoded
        f.response :json, :content_type => /\bjson$/
        faraday.call(f) if faraday
        f.adapter Faraday.default_adapter unless faraday
      end
    end

    def auth_url
      ENVIRONMENTS[environment][:auth_url]
    end

    def token_url
      ENVIRONMENTS[environment][:token_url]
    end

    def api_url
      ENVIRONMENTS[environment][:api_url]
    end
  end
end
