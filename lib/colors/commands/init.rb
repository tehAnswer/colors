module Colors
  module Commands
    class Init < Dry::Struct
      attribute :rows, Type::Coercible::Int
      attribute :columns, Type::Coercible::Int
    end
  end
end
