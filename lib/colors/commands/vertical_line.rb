module Colors
  module Commands
    class VerticalLine < Dry::Struct
      constructor_type :schema

      attribute :start_row, Type::Coercible::Int
      attribute :end_row,   Type::Coercible::Int
      attribute :column,    Type::Coercible::Int
      attribute :color,     Type::Coercible::String
      attribute :line,      Type::Coercible::Int
      attribute :name,      Type::Strict::Symbol.default(:vertical_line)

      def initialize(params)
        params.slice(:column, :end_row, :start_row).each do |k, v|
          Colors::Boundaries.check(k, v)
        end
        super(params)
      end
    end
  end
end
