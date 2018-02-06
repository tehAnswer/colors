module Colors
  module Commands
    class Init < Dry::Struct
      attribute :rows,    Type::Coercible::Int
      attribute :columns, Type::Coercible::Int

      def initialize(params)
        params.slice(:rows, :columns).each do |k, v|
          Colors::Boundaries.check(k, v)
        end
        super(params)
      end
    end
  end
end
