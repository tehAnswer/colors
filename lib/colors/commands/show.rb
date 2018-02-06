module Colors
  module Commands
    class Show < Dry::Struct
      attribute :line, Type::Coercible::Int
    end
  end
end
