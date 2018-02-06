module Colors
  module Commands
    class Pixel < Dry::Struct
      constructor_type :schema

      attribute :row,    Type::Coercible::Int
      attribute :column, Type::Coercible::Int
      attribute :color,  Type::Coercible::String
      attribute :line,   Type::Coercible::Int
      attribute :name,   Type::Strict::Symbol.default(:pixel)

      def initialize(params)
        params.slice(:row, :column).each do |k, v|
          Colors::Boundaries.check(k,v)
        end
        super(params)
      end
    end
  end
end
