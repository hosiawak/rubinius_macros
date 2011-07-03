module Rubinius
  module AST

    class Goto < Node
      def initialize(line, label)
        @line = line
        @label = label
      end

      def bytecode(g)
        pos(g)
        g.goto Label.get(@label, g)
      end
    end

    class Label < Node
      def initialize(line, label)
        @line = line
        @label = label
      end

      def self.get(label, g)
        prefix = g.state.name
        key = "#{prefix}#{label}".to_sym
        @labels ||= { }
        if l = @labels[key]
          return l
        else
          @labels[key] = Rubinius::Generator::Label.new(g)
        end
      end

      def bytecode(g)
        pos(g)
        self.class.get(@label, g).set!
      end
    end
  end
end

module Macros
  module Goto
    def process_fcall(line, name, arguments)
      if arguments
        case name
        when :goto
          label = arguments.body.first.value
          return Rubinius::AST::Goto.new(line, label)
        when :label
          label = arguments.body.first.value
          return Rubinius::AST::Label.new(line, label)
        end
      end
      super
    end
  end
end

