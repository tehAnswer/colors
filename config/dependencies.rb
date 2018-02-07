require 'dry/container'

module Type
  include Dry::Types.module
end

class Dependencies
  extend Dry::Container::Mixin

  register(:parser)           { Colors::Parser.new          }
  register(:interpreter)      { Colors::Interpreter.new     }
  register(:semantic_checker) { Colors::SemanticChecker.new }
end
