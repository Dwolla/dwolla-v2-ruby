module DwollaV2
  class Response
    extend Forwardable

    # http://ruby-doc.org/core-2.3.0/Enumerable.html
    ENUMERABLE = \
      [:all?, :any?, :chunk, :chunk_while, :collect, :collect_concat, :count, :cycle,
       :detect, :drop, :drop_while, :each_cons, :each_entry, :each_slice, :each_with_index,
       :each_with_object, :entries, :find, :find_all, :find_index, :first, :flat_map, :grep,
       :grep_v, :group_by, :include?, :inject, :lazy, :map, :max, :max_by, :member?, :min,
       :min_by, :minmax, :minmax_by, :none?, :one?, :partition, :reduce, :reject,
       :reverse_each, :select, :slice_after, :slice_before, :slice_when, :sort, :sort_by,
       :take, :take_while, :to_a, :to_h, :zip]

    delegate [:status, :headers, :body] => :@response
    delegate [*ENUMERABLE, :==, :[]] => :response_body

    def initialize response
      @response = response
    end

    private

    def response_body
      @response.body
    end
  end
end
