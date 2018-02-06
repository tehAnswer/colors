module Colors
  module Commands
    class Clear < Dry::Struct
      constructor_type :schema

      attribute :line, Type::Coercible::Int
      attribute :name, Type::Strict::Symbol.default(:clear)
    end
  end
end
