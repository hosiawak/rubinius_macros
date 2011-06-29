module Macros
  module Andand
    def process_call(line, receiver, name, arguments)
      if receiver.kind_of?(Rubinius::AST::Send) && receiver.name == :andand
        local_var = gensym
        assgn = Rubinius::AST::LocalVariableAssignment.new(line, local_var, receiver.receiver)
        left = Rubinius::AST::LocalVariableAccess.new(line, local_var)
        if arguments
          # SendWithArguments
          right = Rubinius::AST::SendWithArguments.new(line, left, name, arguments)
        else
          # Send
          right = Rubinius::AST::Send.new(line, left, name)
        end
        and_node = Rubinius::AST::And.new(line, left, right)
        Rubinius::AST::Block.new(line, [assgn, and_node])
      else
        super
      end
    end

    def process_iter(line, method_send, arguments, body)
      if method_send.kind_of?(Rubinius::AST::Block)
        # [1,2,3].andand.inject {|sum,n| sum + n}
        method_send.array.last.right.block = Rubinius::AST::Iter.new(line, arguments, body)
        method_send
      elsif method_send.name == :andand
        # 'foo'.andand {|fu| fu }
        # fu = 'foo' and fu
        assgn = Rubinius::AST::LocalVariableAssignment.new(line, arguments.name, method_send.receiver)
        Rubinius::AST::And.new(line, assgn, body)
      else
        super
      end
    end

    def process_block_pass(line, method_send, body)
      if method_send.kind_of?(Rubinius::AST::Block)
        # [1,2].andand.map(&:to_s)
        body = Rubinius::AST::LocalVariableAccess.new(line, body.name)
        method_send.array.last.right.block = Rubinius::AST::BlockPass.new(line, body)
        method_send
      else
        super
      end
    end
  end
end

