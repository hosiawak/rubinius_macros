# rubinius_macros

It is a set of macros running on Rubinius that add custom syntactical elements and functionality to the language.
The macros utilize parser/compiler architecture and transform AST and generate custom bytecode for each macro.

The idea occured to me after playing with Rubinius bytecode compiler in an irb session: https://gist.github.com/1021515

## It's similar to Rewrite Rails

but instead of using an external parser to parse .rr files and modify AST it uses Rubinius' compiler to achieve it.
The implementation is much simpler.

In addition to AST some of the macros generate custom bytecode for some macros (Recur)

## Goals:

Provide a set of macros to use with Ruby (eg. SymbolToProc, Andand, Returning, Recur and many more)

## How to use ?

1. Apply this patch https://gist.github.com/1293642 to your cloned copy of Rubinius

2. To rebuild Rubinius kernel with the applied patch run:

    rake kernel

3. Run your code with macros:

    rbx -rlib/rubinius_macros your_script.rb

## How to run specs ?

    rbx gem install rspec
    rbx -rlib/rubinius_macros -S rspec spec