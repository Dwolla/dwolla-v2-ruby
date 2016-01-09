module Dwolla
  class SymbolizeResponseBody
    def initialize app
      @app = app
    end

    def call request_env
      @app.call(request_env).on_complete do |response_env|
        response_env.body = Util.deep_symbolize_keys(response_env.body)
      end
    end
  end
end
