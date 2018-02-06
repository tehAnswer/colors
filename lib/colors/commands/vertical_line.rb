module Colors
  module Commands
    class VerticalLine < Dry::Struct
      attribute :start_row, Type::Coercible::Int
      attribute :end_row,   Type::Coercible::Int
      attribute :column,    Type::Coercible::Int
      attribute :color,     Type::Coercible::String
    end
  end
end
