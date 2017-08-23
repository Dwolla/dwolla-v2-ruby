module DwollaV2
  class Response
    extend Forwardable

    delegate [:to_s, :to_json] => :response_body

    def initialize response
      @response = response
    end

    def response_status
      @response.status
    end

    def response_headers
      if @response.respond_to? :response_headers
        @response.response_headers
      elsif @response.respond_to? :headers
        @response.headers
      end
    end

    def respond_to? method, include_private = false
      super || response_body.respond_to?(method)
    end

    def is_a? klass
      super || response_body.is_a?(klass)
    end

    def kind_of? klass
      super || response_body.kind_of?(klass)
    end

    def == other
      super || response_body == other
    end

    def method_missing method, *args, &block
      if response_body.respond_to? method
        response_body.public_send method, *args, &block
      else
        super
      end
    end

    def inspect
      Util.pretty_inspect(
        self.class.name,
        { response_status: response_status, response_headers: response_headers },
        response_body
      )
    end

    private

    def response_body
      @response.body
    end
  end
end
