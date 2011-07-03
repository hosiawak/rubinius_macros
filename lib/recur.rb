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
        if g.state.scope.is_a? Rubinius::AST::Define
          if optional_args = g.state.scope.arguments.defaults
            # optional arguments set
            # generate their bytecode onto a new generator
            # and return the generator's ip to skip their bytecode
            gen = optional_args.new_generator(g, "default_args_generator")
            gen.push_state(g.state.scope)
            gen.execute(optional_args)
            return gen.ip
          end
        end
        0 # no optional args, position is 0
      end

    end

    class Recur < Node

      def initialize(line, arguments)
        @line = line
        @arguments = arguments
      end

      def bytecode(g)

        @arguments.body.each_with_index do |arg,idx|
          # push each argument result to the stack
          g.execute(arg)
        end

        passed_arg_size = @arguments.body.size

        if passed_arg_size > g.total_args

          if !g.state.scope.arguments.splat
            # recur passed more arguments than defined by the method
            # raise Rubinius::CompileError
            msg = "#{passed_arg_size} arguments passed to recur, expected #{g.total_args} in #{g.state.name}"
            raise Rubinius::CompileError.new(msg)
          else
            # splat arg
            # destructure the rest

            splat_idx = g.total_args
            # def method(*ary)
            # rebind recur(ary[0] - 1, ary[0] * ary[1]) as
            # ary[0] = ary[0] - 1
            # ary[1] = ary[0] * ary[1]
            # ary[n] = recur(n)
            (passed_arg_size-1).downto(splat_idx) do |idx|
              g.push_local splat_idx
              g.push_int   idx - splat_idx
              g.swap_stack
              g.rotate     3
              g.send :[]=, 2
              g.pop
            end
          end

        end

        if g.total_args > 0
          # pop the values and rebind to vars in reverse order
          (g.total_args - 1).downto(0) do |idx|
            g.set_local idx
            g.pop
          end
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

