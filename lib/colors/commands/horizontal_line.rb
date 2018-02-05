module Colors
  module Commands
    class HorizontalLine < Dry::Struct
      attribute :start_col, Type::Coercible::Int
      attribute :end_col,   Type::Coercible::Int
      attribute :row,       Type::Coercible::Int
      attribute :color,     Type::Coercible::Symbol
    end
  end
end
