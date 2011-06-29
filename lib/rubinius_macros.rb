require 'lib/gensym'
require 'lib/symbol_to_proc'
require 'lib/andand'
require 'lib/goto'
require 'lib/recur'

module Macros

  class Processor < Rubinius::Melbourne
    include Gensym
    include Andand
    include SymbolToProc
    include Goto
    include Recur
  end
end

class Rubinius::Compiler::Parser
  def self.default_processor
    Macros::Processor
  end
end



