#module Rubinius
#  class Compiler
#    class MacroParser < Stage
#      stage :macros
#      next_stage Generator
#
#      def initialize(compiler, last)
#        super
#      end
#
#      def run
#        puts "running macros"
#      end
#    end
#
#    EvalParser.next_stage(MacroParser)
#  end
#end
#
#puts eval("1+1")

# AST Transforms
require 'gensym'

module Macros

  class Processor < Rubinius::Melbourne
    include Gensym
    include Macros::SymbolToProc
  end

  class Compiler
    class Parser < Stage
      attr_accessor :processor
    end
  end
end
