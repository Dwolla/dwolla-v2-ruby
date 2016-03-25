module DwollaV2
  class Error < StandardError
    extend Forwardable

    delegate [:status] => :@response
    delegate [:to_s, :to_json] => :response_body

    def self.raise! response
      unless response.respond_to? :body
        response = turn_into_response(response)
      end
      if response.body.is_a?(Hash) && klass = error_class(response.body[:error] || response.body[:code])
        raise klass, response, caller
      else
        raise self, response, caller
      end
    end

    def initialize response
      @response = response
    end

    def headers
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

    def message
      to_s
    end

    def to_str
      nil
    end

    def inspect
      Util.pretty_inspect self.class.name, { status: status, headers: headers }, response_body
    end

    private

    def self.turn_into_response response
      OpenStruct.new status: nil,
                     headers: nil,
                     body: Util.deep_super_hasherize(Util.deep_parse_iso8601_values response)
    end

    def self.error_class error_code
      DwollaV2.const_get "#{Util.classify(error_code).chomp("Error")}Error" rescue false
    end

    def response_body
      @response.body
    end
  end
end
