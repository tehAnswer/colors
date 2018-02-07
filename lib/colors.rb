require 'dry-struct'
require 'colorize'
require_relative '../config/dependencies'


Dir[File.expand_path('../colors/**/*.rb', __FILE__)].each { |f| require f }

module Colors
  ParseError = Class.new(StandardError)
  RuntimeError = Class.new(StandardError)

  def self.execute(file_path)
    commands = Dependencies[:parser].parse(file_path)
    semantic_results = Dependencies[:semantic_checker].check(commands)
    Dependencies[:interpreter].execute(commands, semantic_results)
  rescue Colors::RuntimeError => e
    print "Program exit with code 1.".red
  rescue Colors::ParseError => e
    puts "Error while parsing: #{e.message}".red
  end
end
