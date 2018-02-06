module Colors
  module Boundaries
    def self.check(concept, value)
      return if value.to_i.between?(1, 250)
      raise ArgumentError, "Incorrect value for #{concept}, it should be between 1 and 250"
    end
  end
end
