require 'dry-struct'

module Type
  include Dry::Types.module
end

Dir[File.expand_path('../colors/**/*.rb', __FILE__)].each { |f| require f }

module Colors
  ParseError = Class.new(StandardError)
end
