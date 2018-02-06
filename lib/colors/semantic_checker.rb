module Colors
  class SemanticChecker

    def initialize
      @commands = []
      @state = :empty
    end

    def check(commands)
      commands.each_with_index.map do |cmd, index|
        next_commands = command.drop(index + 1)
        send(:"check_#{command.name}", cmd, next_commands)
      ensure
        @commands.unshift(cmd)
      end
    end

    private

    def check_init(cmd, _)
      @state = :initialized
      nil
    end

    def check_pixel(cmd, next_commands)
      not_init_error(cmd) || oob_errors(cmd, next_commands) || useless_line_warning(cmd, next_commands)
    end

    def check_vertical_line(cmd, next_commands)
      not_init_error(cmd) || oob_errors(cmd, next_commands) || useless_line_warning(cmd, next_commands)
    end

    def check_horizontal_line(cmd)
      not_init_error(cmd) || oob_errors(cmd, next_commands) || useless_line_warning(cmd, next_commands)
    end

    def check_show(cmd)
      not_init_error(cmd)
      @state = :showed
    end

    def check_clear(cmd)
      not_init_error(cmd)
      @state = :clear
    end


    def not_initialized_board(cmd)
      { errors: ["Not initialized board to paint on before. (L:#{cmd.line})"] } if @state == :empty
    end

    def useless_line_warning(cmd, next_commands)
      next_init_index  = next_commands.index { |c| c.name == :init  }
      next_show_index  = next_commands.index { |c| c.name == :show  }
      next_clear_index = next_commands.index { |c| c.name == :clear }
      message = case
                when next_show_index.nil?
                  "Ignoring extra line. (L:#{cmd.line})"
                when next_init_index && (next_init_index < next_show_index)
                  "Ignoring line due to board overwrite on line #{next_init_index}. (L:#{cmd.line})"
                when next_clear_index && (next_clear_index < next_show_index)
                  "Ignoring line due to clear overwrite on line #{next_clear_index}. (L:#{cmd.line})"
                else
                  nil
                end
      { warnings: [message] } if message
    end

    def oob_errors(cmd)
      errors = search_for(:init).to_h.slice(:rows, :columns).map do |dimension, max_dimension|
        # Cheap singularize.
        dimension_attribute = dimension.to_s.chomp.to_sym
        cmd.attributes.to_h.map do |cmd_attribute, value|
          next unless cmd_attribute.includes?(dimension_attribute)
          Colors::Boundaries.check(cmd_attribute, value, max: max_dimension)
        rescue ArgumentError => e
          e.message
        end.compact
      end.flatten
      { errors: errors } unless errors.empty?
    end

    def search_for(cmd_name)
      @command.first { |cmd| cmd.name == cmd_name }
    end

    def index_of(cmd_name)
      @command.index { |cmd| cmd.name == cmd_name }
    end
  end
end
