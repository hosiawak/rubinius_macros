module Macros
  module Swap
    def process_fcall(line, name, arguments)
      if name == :swap
        if arguments.body.size != 2
          raise Rubinius::CompileError.new("number of args to swap must be 2")
        end

        a1 = arguments.body[0]
        a2 = arguments.body[1]

        aleft = [a1, a2].map { |x| klass_assgn(x).new(line, x.name, nil)}
        left = Rubinius::AST::ArrayLiteral.new(line, aleft)

        aright = [a2, a1].map { |x| x.class.new(line, x.name)}
        right = Rubinius::AST::ArrayLiteral.new(line, aright)

        Rubinius::AST::MultipleAssignment.new(line, left, right, nil)
      else
        super
      end
    end

    protected
    def klass_assgn(obj)
      case obj
      when Rubinius::AST::LocalVariableAccess
        Rubinius::AST::LocalVariableAssignment
      when Rubinius::AST::InstanceVariableAccess
        Rubinius::AST::InstanceVariableAssignment
      when Rubinius::AST::ClassVariableAccess
        Rubinius::AST::ClassVariableAssignment
      when Rubinius::AST::GlobalVariableAccess
        Rubinius::AST::GlobalVariableAssignment
      end
    end
  end
end

