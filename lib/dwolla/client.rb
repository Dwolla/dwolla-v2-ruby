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
      raise ArgumentError.new "id is required" unless opts[:id].is_a? String
      raise ArgumentError.new "secret is required" unless opts[:secret].is_a? String
      @id = opts[:id]
      @secret = opts[:secret]
      configure :prod
      @auth_url = opts[:auth_url] if opts[:auth_url]
      @token_url = opts[:token_url] if opts[:token_url]
      @api_url = opts[:api_url] if opts[:api_url]
    end

    def configure preset
      raise ArgumentError.new "#{preset} is not a valid config" unless PRESETS.has_key? preset
      PRESETS[preset].each {|k,v| instance_variable_set :"@#{k}", v }
    end

    def on_grant &callback
      @on_grant ||= []
      @on_grant.push callback if callback
      @on_grant
    end

    def conn &block
      raise ArgumentError.new "config block has already been passed to conn" if block && @conn
      @conn ||= Faraday.new &block
    end
  end
end
