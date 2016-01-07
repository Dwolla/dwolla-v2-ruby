module Dwolla
  class Error < StandardError
    attr_reader :error, :error_description, :error_uri

    def self.raise! error
      raise self.new unless error.is_a? Hash
      if error[:error] == "invalid_client"
        raise InvalidClientError.new error
      else
        raise self.new error
      end
    end

    def initialize params = {}
      @error = params[:error]
      @error_description = params[:error_description]
      @error_uri = params[:error_uri]
    end
  end
end
