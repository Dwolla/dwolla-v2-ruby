module Dwolla
  class Client
    ENVIRONMENTS = {
      :default => {
        :auth_url  => "https://www.dwolla.com/authorize",
        :token_url => "https://www.dwolla.com/rest/token",
        :api_url   => "https://api.dwolla.com"
      },
      :sandbox => {
        :auth_url  => "https://uat.dwolla.com/authorize",
        :token_url => "https://uat.dwolla.com/rest/token",
        :api_url   => "https://api-uat.dwolla.com"
      }
    }

    attr_reader :id, :secret

    def initialize opts
      raise ArgumentError.new "id is required" unless opts[:id].is_a? String
      raise ArgumentError.new "secret is required" unless opts[:secret].is_a? String
      @id = opts[:id]
      @secret = opts[:secret]
      yield self if block_given?
      # conn
      freeze
    end

    def environment= env
      raise ArgumentError.new "invalid environment" unless ENVIRONMENTS.has_key? env
      @environment = env
    end

    def environment
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

    # def conn &block
    #   @conn ||= Faraday.new &block
    # end

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
