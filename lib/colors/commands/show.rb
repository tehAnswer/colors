module Colors
  module Commands
    class Show < Dry::Struct
      constructor_type :schema

      attribute :line, Type::Coercible::Int
      attribute :name, Type::Strict::Symbol.default(:show)
    end
  end
end
