module Colors
  module Commands
    class Clear < Dry::Struct
      attribute :line, Type::Coercible::Int
    end
  end
end
