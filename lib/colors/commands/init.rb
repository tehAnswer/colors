module Colors
  module Commands
    class Init < Dry::Struct
      constructor_type :schema

      attribute :rows,    Type::Coercible::Int
      attribute :columns, Type::Coercible::Int
      attribute :line,    Type::Coercible::Int
      attribute :name,    Type::Strict::Symbol.default(:init)

      def initialize(params)
        params.slice(:rows, :columns).each do |k, v|
          Colors::Boundaries.check(k, v)
        end
        super(params)
      end
    end
  end
end
