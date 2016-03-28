module DwollaV2
  class DeepSuperHasherizeResponseBody
    def initialize app
      @app = app
    end

    def call request_env
      @app.call(request_env).on_complete do |response_env|
        response_env.body = Util.deep_super_hasherize(response_env.body)
      end
    end
  end
end
