module Dwolla
  module Util
    def self.parse_json string
      deep_symbolize_keys JSON.parse(string)
    end

    def self.deep_symbolize_keys obj
      if obj.is_a? Hash
        Hash[obj.map{|k,v| [k.to_sym, deep_symbolize_keys(v)] }]
      elsif obj.is_a? Array
        obj.map {|i| deep_symbolize_keys(i) }
      else
        obj
      end
    end
  end
end
