module DwollaV2
  class Client
    extend Forwardable

    ENVIRONMENTS = {
      :production => {
        :auth_url  => "https://accounts.dwolla.com/auth",
        :token_url => "https://api.dwolla.com/token",
        :api_url   => "https://api.dwolla.com"
      },
      :sandbox => {
        :auth_url  => "https://accounts-sandbox.dwolla.com/auth",
        :token_url => "https://api-sandbox.dwolla.com/token",
        :api_url   => "https://api-sandbox.dwolla.com"
      }
    }

    attr_reader :id, :secret, :auths, :tokens
    alias_method :key, :id

    def_delegators :current_token, :get, :post, :delete

    def initialize opts
      opts[:id] ||= opts[:key]
      raise ArgumentError.new ":key is required" unless opts[:id].is_a? String
      raise ArgumentError.new ":secret is required" unless opts[:secret].is_a? String
      @id = opts[:id]
      @secret = opts[:secret]
      self.environment = opts[:environment] if opts.has_key?(:environment)
      yield self if block_given?
      conn
      @auths = Portal.new self, Auth
      @tokens = Portal.new self, Token
      @token_manager = TokenManager.new(self)
      freeze
    end

    def environment= env
      env = :"#{env}"
      raise ArgumentError.new "invalid environment" unless ENVIRONMENTS.has_key? env
      @environment = env
    end

    def environment env = nil
      self.environment = env unless env.nil?
      @environment || :production
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
        f.use SetUserAgent
        f.use HandleErrors
        f.use DeepSuperHasherizeResponseBody
        f.use DeepParseIso8601ResponseBody
        f.response :json, :content_type => /\bjson$/
        faraday.call(f) if faraday
        f.adapter Faraday.default_adapter unless faraday
      end
    end

    def auth(params = {})
      DwollaV2::Auth.new(self, params)
    end

    def refresh_token(params = {})
      unless params.is_a?(Hash) && params.has_key?(:refresh_token)
        raise ArgumentError.new(":refresh_token is required")
      end
      auths.refresh(params, params)
    end

    def token(params = {})
      tokens.new(params)
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

    def inspect
      Util.pretty_inspect self.class.name, key: id, environment: environment
    end

    private

      def current_token
        @token_manager.get_token
      end
  end
end
