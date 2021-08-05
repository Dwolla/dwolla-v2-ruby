module DwollaV2
  class TokenManager
    def initialize(client)
      @client = client
      @current_token = nil
      @mutex = Mutex.new
    end

    def get_token
      @mutex.synchronize do
        if !@current_token || @current_token.is_expired?
          @current_token = fetch_new_token
        else
          @current_token
        end
      end
    end

    private

      def fetch_new_token
        @client.auths.client
      end
  end
end
