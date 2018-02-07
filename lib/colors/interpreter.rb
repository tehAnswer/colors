module Colors
  # The interpreter, having as an input the results from the semantic anylisis,
  # executes commands if it proceeds. It first scans the semantic results for
  # any errors, to ensure that only valid scripts are executed.
  #
  # If none errors were found, then it proceeds to execute each command. It also
  # has the notion of warning. I was inspired by compilers optimizations to do
  # this feature. In two words, the Interpreter won't execute a useless command.
  class Interpreter
    attr_reader :data

    def initialize
      @columns = nil
      @data = nil
    end

    def execute(commands, semantic_results)
      scan_errors!(semantic_results)
      commands.zip(semantic_results).each do |command, warning|
        if warning
          warning[:warnings].each { |w| puts w.yellow }
        else
          send(:"execute_#{command.name}", command)
        end
      end
    end

    def execute_init(command)
      @columns = command.columns
      @data = Array.new(command.rows * command.columns) { :white }
    end

    def execute_clear(_)
      @data = Array.new(@data.length) { :white }
    end

    def execute_show(_)
      @data.each_with_index do |element, index|
        print ' '.colorize(background: element)
        print "\n" if (index + 1) % @columns == 0
      end
    end

    def execute_vertical_line(command)
      column, row1, row2 = command.to_h.slice(:column, :start_row, :end_row).values
      Range.new(*[row1, row2].sort).each do |row|
        @data[column - 1 + (row - 1) * @columns] = command.color.to_sym
      end
    end

    def execute_horizontal_line(command)
      row, col1, col2 = command.to_h.slice(:row, :start_column, :end_column).values
      Range.new(*[col1, col2].sort).each do |column|
        @data[column - 1 + (row - 1) * @columns] = command.color.to_sym
      end
    end

    def execute_pixel(command)
      @data[(command.row - 1) * @columns + command.column - 1] = command.color.to_sym
    end

    def scan_errors!(semantic_results)
      errors = semantic_results.select { |r| r&.has_key?(:errors) }.map { |h| h[:errors] }.flatten
      unless errors.empty?
        errors.each { |e| puts e.red }
        raise Colors::RuntimeError
      end
    end
  end
end
