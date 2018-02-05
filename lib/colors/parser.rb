module Colors
  class Parser
    def initialize
      @commands = []
    end

    def parse(file_path)
      File.foreach(file_path) do |line|
        tokens = line.split(' ')
        commands << command_for(tokens.first, tokens.drop(1))
      end
    end

    private

    def command_for(initial, parameters)
      case tokens.first.upcase
      when 'I'
        data = %i(rows columns).zip(parameters).to_h
        Colors::Commands::Init.new(data)
      when 'C'
        Colors::Commands::Clear.new
      when 'S'
        Colors::Commands::Show.new
      when 'V'
        data = %i(column start_row end_row color).zip(parameters)
        Colors::Commands::VerticalLine.new(data.to_h)
      when 'H'
        data = %i(start_col end_col row color).zip(parameters)
        Colors::Commands::HorizontalLine.new(data.to_h)
      end
    end
  end
end
