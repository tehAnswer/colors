module Colors
  module Commands
    class HorizontalLine < Dry::Struct
      attribute :start_col, Type::Coercible::Int
      attribute :end_col,   Type::Coercible::Int
      attribute :row,       Type::Coercible::Int
      attribute :color,     Type::Coercible::String
      attribute :line,      Type::Coercible::Int

      def initialize(params)
        params.slice(:start_col, :end_col, :row).each do |k, v|
          Colors::Boundaries.check(k, v)
        end
        super(params)
      end
    end
  end
end
