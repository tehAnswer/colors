module Colors
  module Commands
    class Pixel < Dry::Struct
      attribute :row,    Type::Coercible::Int
      attribute :column, Type::Coercible::Int
      attribute :color,  Type::Coercible::Symbol
    end
  end
end
