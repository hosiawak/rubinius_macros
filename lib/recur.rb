module Rubinius
  module AST

    class BeginningLabel < Rubinius::Generator::Label

      def initialize(generator)
        super
        @position = calc_start_pos(generator)
        @basic_block = generator.new_basic_block
        @generator.current_block.left = @basic_block
        @generator.current_block.close
        @generator.current_block = @basic_block
        @basic_block.open
      end

      def calc_start_pos(g)
        diff = g.total_args - g.required_args
        # some arguments are default
        # move the position pointer
        diff * 8
      end
    end

    class Recur < Node

      def initialize(line, arguments)
        @line = line
        @arguments = arguments
      end

      def bytecode(g)
        # insert label at the beginning of the method

        @arguments.body.each_with_index do |arg,idx|
          # push each argument result to the stack
          g.execute(arg)
        end
        # pop the values and rebind to vars in reverse order
        (@arguments.body.size-1).downto(0) do |idx|
          g.set_local idx
          g.pop
        end

        g.goto BeginningLabel.new(g)

      end
    end
  end
end
module Macros
  module Recur

    def process_fcall(line, name, arguments)

      if name == :recur
        Rubinius::AST::Recur.new(line, arguments)
      else
        super
      end
    end

  end
end

