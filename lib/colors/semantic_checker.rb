module Colors
  class SemanticChecker

    def initialize
      @commands = []
      @state = :empty
    end

    def check(commands)
      commands.each_with_index.map do |cmd, index|
        next_commands = commands.drop(index + 1)
        send(:"check_#{cmd.name}", cmd, next_commands)
      ensure
        @commands.unshift(cmd)
      end
    end

    private

    def check_init(cmd, next_commands)
      @state = :initialized
      extra_line_warning(cmd, next_commands) || board_overwrite_warning(cmd, next_commands)
    end

    def check_pixel(cmd, next_commands)
      not_init_error(cmd) || oob_errors(cmd) || useless_line_warning(cmd, next_commands)
    end

    def check_vertical_line(cmd, next_commands)
      not_init_error(cmd) || oob_errors(cmd) || useless_line_warning(cmd, next_commands)
    end

    def check_horizontal_line(cmd, next_commands)
      not_init_error(cmd) || oob_errors(cmd) || useless_line_warning(cmd, next_commands)
    end

    def check_show(cmd, _)
      not_init_error(cmd)
      @state = :showed
      nil
    end

    def check_clear(cmd, _)
      not_init_error(cmd)
      @state = :clear
      nil
    end

    def not_init_error(cmd)
      { errors: ["Not initialized board to paint on. (L:#{cmd.line})"] } if @state == :empty
    end

    def extra_line_warning(cmd, next_commands)
      return nil if next_commands.index { |c| c.name == :show  }
      { warnings: ["Ignoring extra line; missing show command afterwards. (L:#{cmd.line})"] }
    end

    def board_overwrite_warning(cmd, next_commands)
      next_show_index  = next_commands.index { |c| c.name == :show  }
      next_init_index  = next_commands.index { |c| c.name == :init  }
      return nil unless next_init_index && (next_init_index < next_show_index)

      init_line = next_commands[next_init_index].line
      { warnings: ["Ignoring line due to board overwrite on line #{init_line}. (L:#{cmd.line})"] }
    end

    def clear_overwrite_warning(cmd, next_commands)
      next_show_index  = next_commands.index { |c| c.name == :show  }
      next_clear_index = next_commands.index { |c| c.name == :clear }
      return nil unless next_clear_index && (next_clear_index < next_show_index)

      clear_line = next_commands[next_clear_index].line
      { warnings: ["Ignoring line due to clear overwrite on line #{clear_line}. (L:#{cmd.line})"] }
    end

    def useless_line_warning(cmd, next_commands)
      extra_line_warning(cmd, next_commands) || board_overwrite_warning(cmd, next_commands) || clear_overwrite_warning(cmd, next_commands)
    end

    def oob_errors(cmd)
      errors = search_for(:init).to_h.slice(:rows, :columns).map do |dimension, max_dimension|
        # Cheap singularize.
        dimension_attribute = dimension.to_s.chop.to_sym
        cmd.to_h.map do |cmd_attribute, value|
          begin
            next unless cmd_attribute.to_s.include?(dimension_attribute.to_s)
            Colors::Boundaries.check(cmd_attribute, value, max: max_dimension)
          rescue ArgumentError => e
            e.message + " (L:#{cmd.line})"
          end
        end.compact
      end.flatten
      { errors: errors } unless errors.empty?
    end

    def search_for(cmd_name)
      @commands.find { |cmd| cmd.name == cmd_name }
    end

    def index_of(cmd_name)
      @commands.index { |cmd| cmd.name == cmd_name }
    end
  end
end
