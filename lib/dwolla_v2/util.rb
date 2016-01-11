module DwollaV2
  module Util
    def self.deep_symbolize_keys obj
      if obj.is_a? Hash
        Hash[obj.map{|k,v| [k.to_sym, deep_symbolize_keys(v)] }]
      elsif obj.is_a? Array
        obj.map {|i| deep_symbolize_keys(i) }
      else
        obj
      end
    end

    def self.classify str
      str.split("_").map do |i|
        i.sub(/^(.)/) { $1.capitalize }
      end.join
    end
  end
end
