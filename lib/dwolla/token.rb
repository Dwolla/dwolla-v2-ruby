module Dwolla
  class Token
    attr_reader :client, :access_token, :refresh_token, :expires_in, :account_id

    def initialize client, params
      self.client = client
      self.access_token = params[:access_token]
      self.refresh_token = params[:refresh_token]
      self.expires_in = params[:expires_in]
      self.account_id = params[:account_id]
    end

    def stringify_keys
      {
        "access_token"  => access_token,
        "refresh_token" => refresh_token,
        "expires_in"    => expires_in,
        "account_id"    => account_id
      }.reject {|k,v| v.nil? }
    end

    private

    def client= val
      raise ArgumentError.new "client must be a Dwolla::Client" unless val.is_a? Client
      @client = val
    end

    def access_token= val
      raise ArgumentError.new "access_token must be a String" unless val.is_a? String
      @access_token = val
    end

    def refresh_token= val
      raise ArgumentError.new "refresh_token must be a String" unless val.nil? || val.is_a?(String)
      @refresh_token = val
    end

    def expires_in= val
      raise ArgumentError.new "expires_in must be an Integer" unless val.nil? || val.is_a?(Integer)
      @expires_in = val
    end

    def account_id= val
      raise ArgumentError.new "account_id must be a String" unless val.nil? || val.is_a?(String)
      @account_id = val
    end
  end
end
