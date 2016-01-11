module DwollaV2
  class Error < StandardError
    attr_reader :error, :error_description, :error_uri, :code, :message, :_links, :_embedded

    def self.raise! error
      raise self.new unless error.is_a? Hash
      if klass = error_class(error[:error] || error[:code])
        raise klass.new error
      else
        raise self.new error
      end
    end

    def initialize params = {}
      @error = params[:error]
      @error_description = params[:error_description]
      @error_uri = params[:error_uri]
      @code = params[:code]
      @message = params[:message]
      @_links = params[:_links]
      @_embedded = params[:_embedded]
    end

    def to_s
      [:error, :error_description, :error_uri, :code, :message, :_links, :_embedded]
        .map {|a| "#{a}: \"#{public_send(a)}\"" if public_send(a) }
        .compact
        .join ", "
    end

    private

    def self.error_class error_code
      DwollaV2.const_get "#{Util.classify(error_code).chomp("Error")}Error" rescue false
    end
  end
end
