require 'lib/gensym'
require 'lib/swap'
require 'lib/symbol_to_proc'
require 'lib/string_to_proc'
require 'lib/andand'
require 'lib/goto'
require 'lib/recur'

module Macros

  class Processor < Rubinius::Melbourne
    include Gensym
    include Swap
    include Andand
    include SymbolToProc
    include StringToProc
    include Goto
    include Recur
  end
end

class Rubinius::Compiler::Parser
  def self.processor
    Macros::Processor
  end
end



