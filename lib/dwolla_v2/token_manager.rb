module DwollaV2
  class TokenManager
    def initialize(client)
      @client = client
      @wrapped_token = nil
      @mutex = Mutex.new
    end

    def get_token
      @mutex.synchronize do
        current_token = @wrapped_token || fetch_new_token()
        fresh_token = current_token.is_expired? ? fetch_new_token() : current_token
        @wrapped_token = fresh_token unless @wrapped_token == fresh_token
        fresh_token.token
      end
    end

    private

      def fetch_new_token
        TokenWrapper.new(@client.auths.client)
      end
  end

  class TokenWrapper
    EXPIRES_IN_LEEWAY = 60

    attr_reader :token

    def initialize(token)
      @token = token
      @expires_at = Time.now.utc + @token.expires_in - EXPIRES_IN_LEEWAY
    end

    def is_expired?
      @expires_at < Time.now.utc
    end
  end
end
