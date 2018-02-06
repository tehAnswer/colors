module Colors
  module Commands
    class HorizontalLine < Dry::Struct
      constructor_type :schema

      attribute :start_column, Type::Coercible::Int
      attribute :end_column,   Type::Coercible::Int
      attribute :row,          Type::Coercible::Int
      attribute :color,        Type::Coercible::String
      attribute :line,         Type::Coercible::Int
      attribute :name,         Type::Strict::Symbol.default(:horizontal_line)

      def initialize(params)
        params.slice(:start_column, :end_column, :row).each do |k, v|
          Colors::Boundaries.check(k, v)
        end
        super(params)
      end
    end
  end
end
