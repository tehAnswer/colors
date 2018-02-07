require 'dry-struct'
require 'colorize'

module Type
  include Dry::Types.module
end

Dir[File.expand_path('../colors/**/*.rb', __FILE__)].each { |f| require f }

module Colors
  ParseError = Class.new(StandardError)
  RuntimeError = Class.new(StandardError)

  def execute(file_path)
    commands = Depedencies[:parser].parse(file_path)
    semantic_results = Dependencies[:semantic_checker].check(commands)
    Dependencies[:interpreter].execute(commands, semantic_results)
  rescue Colors::RuntimeError
    puts 'Program exit with code 1.'
  end
end
