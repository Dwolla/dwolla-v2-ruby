module Dwolla
  class Auth
    def self.client client, params = {}
      raise ArgumentError.new "client must be a Dwolla::Client" unless client.is_a? Client
      request_token client, {:grant_type => "client_credentials"}.merge(params)
    end

    private

    def self.request_token client, params
      res = client.conn.post do |req|
        req.headers["Authorization"] = basic_auth client
        req.url client.token_url
        req.body = URI.encode_www_form(params)
      end
      if res.status == 200
        Token.new client, parse_json(res.body)
      else
        Error.new parse_json(res.body)
      end
    end

    def self.basic_auth client
      "Basic #{Base64.encode64("#{client.id}:#{client.secret}")}"
    end

    def self.parse_json string
      deep_symbolize_keys JSON.parse(string)
    end

    def self.deep_symbolize_keys obj
      if obj.is_a? Hash
        Hash[obj.map{|k,v| [k.to_sym, deep_symbolize_keys(v)] }]
      elsif obj.is_a? Array
        obj.map {|i| deep_symbolize_keys i }
      else
        obj
      end
    end
  end
end
