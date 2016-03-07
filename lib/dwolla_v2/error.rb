module DwollaV2
  class Error < StandardError
    def self.raise! error
      raise self.new unless error.is_a? Hash
      if klass = error_class(error[:error] || error[:code])
        raise klass.new error
      else
        raise self.new error
      end
    end

    def initialize error = nil
      @error = error
    end

    def message
      @error[:message]
    end

    def [] key
      @error[key] rescue nil
    end

    def method_missing method
      @error[method] rescue nil
    end

    def to_s
      @error.to_s
    end

    private

    def self.error_class error_code
      DwollaV2.const_get "#{Util.classify(error_code).chomp("Error")}Error" rescue false
    end
  end
end
