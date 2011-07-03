module Macros
  module Swap
    def process_fcall(line, name, arguments)
      if name == :swap
        if arguments.body.size != 2
          raise Rubinius::CompileError.new("number of args to swap must be 2")
        end

        a1 = arguments.body[0].name
        a2 = arguments.body[1].name
        aleft = [a1, a2].map { |x| Rubinius::AST::LocalVariableAssignment.new(line, x, nil)}
        left = Rubinius::AST::ArrayLiteral.new(line, aleft)
        aright = [a2, a1].map { |x| Rubinius::AST::LocalVariableAccess.new(line, x)}
        right = Rubinius::AST::ArrayLiteral.new(line, aright)
        Rubinius::AST::MultipleAssignment.new(line, left, right, nil)
      else
        super
      end
    end
  end
end

