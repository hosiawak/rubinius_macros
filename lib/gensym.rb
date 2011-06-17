module Macros
  module Gensym
    def default_generator
      lambda { :"__#{Time.now.to_i}#{rand(100000)}__" }
    end

    def gensym
      (@gensym_generator ||= default_generator).call()
    end

    def define_gensym(&block)
      @gensym_generator = block
    end
  end
end

