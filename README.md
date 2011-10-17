# rubinius_macros

It is a set of macros running on Rubinius that add custom syntactical elements and functionality to the language.
The macros utilize parser/compiler architecture and transform AST and generate custom bytecode for each macro.

The idea occured to me after playing with Rubinius bytecode compiler in an irb session: https://gist.github.com/1021515

## It's like Rewrite Rails (but better :) )

Then thinking about the possibility of macros in Ruby I found Raganwald's Rewrite Rails https://github.com/raganwald/rewrite_rails and thus this project emerged.

The main difference between Rewrite Rails and rubinius_macros is rubinius_macros runs on Rubinius and Rubinius has got a very flexible compiler infrastructure.
That's why the macros don't need an external parser/tool and any extra steps to reparse your Ruby program containing macros into something Ruby understands.
This is all done automatically during parsing/bytecode generation stages by Rubinius. Rewrite Rails utilized an external parser for .rr files.

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