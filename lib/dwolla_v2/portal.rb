module DwollaV2
  class Portal
    def initialize parent, klass
      @parent = parent
      @klass = klass
    end

    def method_missing method, *args, &block
      @klass.public_send method, @parent, *args, &block
    end
  end
end
