base = File.dirname(__FILE__)

require base + '/gensym'
require base + '/swap'
require base + '/symbol_to_proc'
require base + '/string_to_proc'
require base + '/andand'
require base + '/goto'
require base + '/recur'

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



