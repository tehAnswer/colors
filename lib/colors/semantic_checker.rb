module Colors
  class SemanticChecker
    using Colors::Refinements::Inflector

    def initialize
      @commands = []
      @state = :empty
    end

    def check(commands)
      errors, warnings = [] []
      commands.map do |cmd|
        send(:"check_#{command.name}", cmd)
      ensure
        @commands.unshift(cmd)
      end
    end

    private

    def check_init(cmd)
    end

    def check_pixel(cmd)
    end

    def check_vertical_line(cmd)
    end

    def check_horizontal_line(cmd)
    end

    def check_show(cmd)
    end

    def check_clear(cmd)
    end

    def search_for(cmd_name)
      @command.first { |cmd| cmd.name == cmd_name }
    end
  end
end
