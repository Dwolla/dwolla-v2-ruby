module DwollaV2
  class Response
    extend Forwardable

    DO_NOT_FORWARD = [:method_missing, :object_id, :__send__]

    delegate instance_methods.reject {|m| DO_NOT_FORWARD.include?(m) } => :response_body
    delegate [:status, :headers] => :@response

    def initialize response
      @response = response
    end

    def method_missing method, *args, &block
      response_body.send method, *args, &block
    end

    private

    def response_body
      @response.body
    end
  end
end
