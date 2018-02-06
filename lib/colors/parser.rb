module Colors
  class Parser

    def parse(file_path)
      commands = []
      File.foreach(file_path) do |line|
        next if is_comment?(line) || line.strip.empty?
        tokens = line.split(' ')
        commands << command_for(tokens.first, tokens.drop(1))
      rescue StandardError  => e
        raise Colors::ParseError.new(e.message)
      end
      commands
    end

    private

    def is_comment?(line)
      line.start_with?(/^(\/\/|#|;;).*$/)
    end

    def command_for(initial, parameters)
      case initial.upcase
      when 'I'
        data = %i(rows columns).zip(parameters).to_h
        Colors::Commands::Init.new(data)
      when 'C'
        raise StandardError, 'Command C does not take arguments.' unless parameters.empty?
        Colors::Commands::Clear.new
      when 'S'
        raise StandardError, 'Command S does not take arguments.' unless parameters.empty?
        Colors::Commands::Show.new
      when 'V'
        data = %i(column start_row end_row color).zip(normalize_color(parameters))
        Colors::Commands::VerticalLine.new(data.to_h)
      when 'H'
        data = %i(start_col end_col row color).zip(normalize_color(parameters))
        Colors::Commands::HorizontalLine.new(data.to_h)
      when 'L'
        data = %i(row column color).zip(normalize_color(parameters))
        Colors::Commands::Pixel.new(data.to_h)
      else
        raise StandardError, "Command #{initial} does not exist."
      end
    end

    def normalize_color(parameters)
      color = color_for(parameters.last)
      parameters[parameters.length - 1] = color
      parameters
    end

    def color_for(abbreviation)
      case abbreviation.upcase
      when 'B' then :black
      when 'W' then :white
      when 'R' then :red
      when 'C' then :cyan
      when 'L' then :light_blue
      when 'V' then :violet
      when 'G' then :green
      when 'Y' then :yellow
      when 'P' then :pink
      else
        raise StandardError, "Unknown color abbreviation #{abbreviation}."
      end
    end
  end
end
