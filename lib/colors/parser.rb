module Colors
  # The Parser is responsible for reading files, extract its tokens and make sense out of those in our reduced
  # grammar. By leveraging typed structs (Dry::Struct), it offers lexical validations.
  class Parser

    def parse(file_path)
      commands = []
      line_number = 1
      # File.foreach is the best way to read files as it's the solution that
      # archives less memory consumption. Basically, the lines are being loaded
      # into memory one by one, which becomes essential when reading larger files.
      #
      # https://felipeelias.github.io/ruby/2017/01/02/fast-file-processing-ruby.html    line_number = 1
      File.foreach(file_path) do |line|
        next if is_comment?(line) || line.strip.empty?
        tokens = line.split(' ')
        commands << command_for(tokens.first, tokens.drop(1), line_number)
      rescue StandardError  => e
        raise Colors::ParseError.new(e.message)
      ensure
        line_number = line_number + 1
      end
      commands
    end

    private

    def is_comment?(line)
      line.start_with?(/^(\/\/|#|;;).*$/)
    end

    def command_for(initial, parameters, line)
      case initial.upcase
      when 'I'
        data = %i(rows columns line).zip(parameters.push(line))
        Colors::Commands::Init.new(data.to_h)
      when 'C'
        raise StandardError, 'Command C does not take arguments.' unless parameters.empty?
        Colors::Commands::Clear.new(line: line)
      when 'S'
        raise StandardError, 'Command S does not take arguments.' unless parameters.empty?
        Colors::Commands::Show.new(line: line)
      when 'V'
        data = %i(column start_row end_row color line).zip(normalize_color(parameters).push(line))
        Colors::Commands::VerticalLine.new(data.to_h)
      when 'H'
        data = %i(start_column end_column row color line).zip(normalize_color(parameters).push(line))
        Colors::Commands::HorizontalLine.new(data.to_h)
      when 'L'
        data = %i(row column color line).zip(normalize_color(parameters).push(line))
        Colors::Commands::Pixel.new(data.to_h)
      else
        raise StandardError, "Command #{initial} does not exist."
      end
    end

    # Translates a color token to a Symbol
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
