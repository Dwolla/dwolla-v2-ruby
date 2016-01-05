module Dwolla
  class Client
    PRESETS = {
      :prod => {
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

    attr_reader :id, :secret, :auth_url, :token_url, :api_url

    def initialize opts
      raise ArgumentError.new "id is required" if opts[:id].nil?
      raise ArgumentError.new "secret is required" if opts[:secret].nil?
      configure :prod
      opts.each {|k,v| self.public_send :"#{k}=", v }
    end

    def id= val
      raise ArgumentError.new "id must be a String" unless val.is_a? String
      @id = val
    end

    def secret= val
      raise ArgumentError.new "secret must be a String" unless val.is_a? String
      @secret = val
    end

    def auth_url= val
      raise ArgumentError.new "auth_url must be a String" unless val.is_a? String
      @auth_url = val
    end

    def api_url= val
      raise ArgumentError.new "api_url must be a String" unless val.is_a? String
      @api_url = val
    end

    def token_url= val
      raise ArgumentError.new "token_url must be a String" unless val.is_a? String
      @token_url = val
    end

    def configure preset
      raise ArgumentError.new "#{preset} is not a valid config" unless PRESETS.has_key? preset
      PRESETS[preset].each {|k,v| self.public_send :"#{k}=", v }
    end

    def on_grant &callback
      @on_grant ||= []
      @on_grant.push callback if callback
      @on_grant
    end

    def conn
      @conn ||= Faraday.new do |faraday|
        faraday.response :logger
      end
    end
  end
end
