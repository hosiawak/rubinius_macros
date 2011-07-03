module Macros
  module SymbolToProc
    def process_block_pass(line, method_send, body)
      if body.class == Rubinius::AST::SymbolLiteral
        # map(&:to_s) == map { |gensym| gensym.to_s }
        name = body.value
        local_var = gensym
        arguments = Rubinius::AST::IterArguments.new(line, Rubinius::AST::LocalVariableAssignment.new(line, local_var, nil))
        receiver = Rubinius::AST::LocalVariableAccess.new line, local_var
        body = Rubinius::AST::Send.new line, receiver, body.value
        iter = Rubinius::AST::Iter.new line, arguments, body
        super line, method_send, iter
      else
        super
      end
    end

    def process_call(line, receiver, name, arguments)
      if name == :to_proc and receiver.is_a? Rubinius::AST::SymbolLiteral
        # :abc.to_proc == proc { |gensym| gensym.abc }
        # .to_proc
        proc_send = Rubinius::AST::Send.new(line, Rubinius::AST::Self.new(line), :proc, true)
        # :abc
        method_name = receiver.value
        # gensym
        block_var_name = gensym
        block_var_access = Rubinius::AST::LocalVariableAccess.new(line, block_var_name)
        block_send = Rubinius::AST::Send.new line, block_var_access, method_name
        block_var_assgn = Rubinius::AST::LocalVariableAssignment.new(line, block_var_name, nil)
        block_args = Rubinius::AST::IterArguments.new(line, block_var_assgn)
        proc_send.block = Rubinius::AST::Iter.new(line, block_var_assgn, block_send)
        proc_send
      else
        super
      end
    end
  end
end

