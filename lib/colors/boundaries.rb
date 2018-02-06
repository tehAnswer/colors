module Colors
  module Boundaries
    def self.check(concept, value, min: 1, max: 250)
      return if value.to_i.between?(min, max)
      raise ArgumentError, "Incorrect value for #{concept}, it should be between #{min} and #{max}."
    end
  end
end
