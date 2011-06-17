module Macros
  module SymbolToProc
    def process_block_pass(line, method_send, body)
      if body.class == Rubinius::AST::SymbolLiteral
        # Symbol#to_proc
        name = body.value
        local_var = gensym
        arguments = Rubinius::AST::IterArguments.new(line, Rubinius::AST::LocalVariableAssignment.new(line, local_var, nil))
        receiver = Rubinius::AST::LocalVariableAccess.new line, local_var
        body = Rubinius::AST::Send.new line, receiver, body.value
        iter = Rubinius::AST::Iter.new line, arguments, body
        super(line, method_send, iter)
      else
        super(line, method_send, body)
      end
    end
  end
end

