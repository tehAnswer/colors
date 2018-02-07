RSpec.describe Colors do
  context 'executes script' do
    let(:file_path) { File.expand_path('../shared/simple_program.txt', __FILE__) }
    let(:board) do
      [
        ' '.colorize(background: :green),
        ' '.colorize(background: :yellow),
        "\n",
        ' '.colorize(background: :red),
        ' '.colorize(background: :cyan),
        "\n"
      ].reduce(:+)
    end

    it 'prints' do
      expect { Colors.execute(file_path) }.to output(board).to_stdout
    end
  end

  context 'executes lexically incorrect script' do
    let(:file_path) { File.expand_path('../shared/invalid_script_lexic.txt', __FILE__) }
    let(:board) { 'Error while parsing: Command S does not take arguments.'.red + "\n" }
    it 'prints errors' do
      expect { Colors.execute(file_path) }.to output(board).to_stdout
    end
  end

  context 'executes semantically incorrect script' do
    let(:file_path) { File.expand_path('../shared/invalid_script_semantics.txt', __FILE__) }
    let(:board) do
      [
        'Incorrect value for start_row (6), it should be between 1 and 5. (L:2)',
        'Incorrect value for row (7), it should be between 1 and 5. (L:3)',
        'Incorrect value for start_column (7), it should be between 1 and 5. (L:3)',
        'Incorrect value for end_column (7), it should be between 1 and 5. (L:3)',
        'Program exit with code 1.'
      ].map(&:red).join("\n")
    end
    it 'prints errors' do
      expect { Colors.execute(file_path) }.to output(board).to_stdout
    end
  end

  context 'executes script with warnings' do
    let(:file_path) { File.expand_path('../shared/warnings_script.txt', __FILE__) }
    let(:board) { 'Error while parsing: Command S does not take arguments.'.red + "\n" }
    it 'prints warnings and board' do
      expect { Colors.execute(file_path) }.to output(board).to_stdout
    end
  end
end
