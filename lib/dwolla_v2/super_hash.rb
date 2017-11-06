module DwollaV2
  class SuperHash < Hash
    include Hashie::Extensions::KeyConversion
    include Hashie::Extensions::MethodAccess
    include Hashie::Extensions::IndifferentAccess
    include Hashie::Extensions::DeepFetch

    def == other
      super(other) || other && super(self.class[other])
    end
  end
end
