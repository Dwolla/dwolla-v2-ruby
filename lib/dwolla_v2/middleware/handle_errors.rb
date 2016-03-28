module DwollaV2
  class HandleErrors
    def initialize app
      @app = app
    end

    def call request_env
      @app.call(request_env).on_complete do |response_env|
        Error.raise!(response_env) if response_env.status >= 400
      end
    end
  end
end
