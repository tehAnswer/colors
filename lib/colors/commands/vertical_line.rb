module Colors
  module Commands
    class VerticalLine < Dry::Struct
      attribute :start_row, Type::Coercible::Int
      attribute :end_row,   Type::Coercible::Int
      attribute :column,    Type::Coercible::Int
      attribute :color,     Type::Coercible::String
      attribute :line,      Type::Coercible::Int

      def initialize(params)
        params.slice(:column, :end_row, :start_row).each do |k, v|
          Colors::Boundaries.check(k, v)
        end
      end
    end
  end
end
