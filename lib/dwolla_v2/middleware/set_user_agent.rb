module DwollaV2
  class SetUserAgent
    HEADERS = {
      :"user-agent" => "dwolla-v2-ruby #{VERSION}"
    }

    def initialize app
      @app = app
    end

    def call request_env
      request_env[:request_headers].merge! HEADERS
      @app.call(request_env)
    end
  end
end
