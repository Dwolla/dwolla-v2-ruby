module DwollaV2
  module Util
    def self.deep_super_hasherize obj
      if obj.is_a? Hash
        SuperHash[obj.map{|k,v| [k, deep_super_hasherize(v)] }]
      elsif obj.is_a? Array
        obj.map {|i| deep_super_hasherize(i) }
      else
        obj
      end
    end

    def self.deep_parse_iso8601_values obj
      if obj.is_a? Hash
        Hash[obj.map{|k,v| [k, deep_parse_iso8601_values(v)] }]
      elsif obj.is_a? Array
        obj.map {|i| deep_parse_iso8601_values(i) }
      elsif obj.is_a? String
        Time.iso8601 obj rescue obj
      else
        obj
      end
    end

    def self.classify str
      str.split("_").map do |i|
        i.sub(/^(.)/) { $1.capitalize }
      end.join
    end

    def self.pretty_inspect klass_name, attrs, append = nil
      [
        "#<#{klass_name}",
        attrs.map {|k,v| " #{k}=#{v.inspect}" unless v.nil? },
        (" #{append.is_a?(String) ? append.inspect : append}" unless append.nil?),
        ">"
      ].flatten.join
    end
  end
end
