module Colors
  module Commands
    class Pixel < Dry::Struct
      attribute :row,    Type::Coercible::Int
      attribute :column, Type::Coercible::Int
      attribute :color,  Type::Coercible::String
      attribute :line,    Type::Coercible::Int

      def initialize(params)
        params.slice(:row, :column).each do |k, v|
          Colors::Boundaries.check(k,v)
        end
        super(params)
      end
    end
  end
end
