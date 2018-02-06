RSpec.describe Colors::Parser do
  let(:instance) { described_class.new }
  subject { instance.parse(file_path)  }

  context 'valid script' do
    let(:file_path) { File.expand_path('../shared/valid_script.txt', __FILE__) }
    let(:commands) do
      [
        Colors::Commands::Init.new(rows: 10, columns: 10, line: 1),
        Colors::Commands::Clear.new(line: 2),
        Colors::Commands::Pixel.new(row: 1, column: 3, color: :black, line: 3),
        Colors::Commands::VerticalLine.new(column: 2, start_row: 1, end_row: 3, color: :white, line: 4),
        Colors::Commands::HorizontalLine.new(start_column: 3, end_column: 5, row: 1, color: :pink, line: 5),
        Colors::Commands::Pixel.new(row: 1, column: 1, color: :pink, line: 6),
        Colors::Commands::Pixel.new(row: 1, column: 2, color: :black, line: 7),
        Colors::Commands::Pixel.new(row: 1, column: 3, color: :green, line: 8),
        Colors::Commands::Pixel.new(row: 1, column: 4, color: :cyan, line: 9),
        Colors::Commands::Pixel.new(row: 1, column: 5, color: :light_blue, line: 10),
        Colors::Commands::Pixel.new(row: 1, column: 6, color: :violet, line: 11),
        Colors::Commands::Pixel.new(row: 1, column: 7, color: :yellow, line: 12),
        Colors::Commands::Pixel.new(row: 1, column: 8, color: :red, line: 13),
        Colors::Commands::Show.new(line: 14)
      ]
    end

    it { is_expected.to eq(commands) }
  end

  context 'invalid script (unknown command)' do
    let(:file_path) { File.expand_path('../shared/unknown_command.txt', __FILE__) }

    it 'throws error' do
      expect { subject }.to raise_error(Colors::ParseError)
    end
  end

  context 'conflicting script (extra spaces)' do
    let(:file_path) { File.expand_path('../shared/extraspaced_script.txt', __FILE__) }
    let(:commands) do
      [
        Colors::Commands::Init.new(rows: 10, columns: 10, line: 1),
        Colors::Commands::VerticalLine.new(column: 1, start_row: 1, end_row: 2, color: :pink, line: 2),
        Colors::Commands::Show.new(line: 7)
      ]
    end

    it { is_expected.to eq(commands) }
  end

  context 'conflicting script (empty)' do
    let(:file_path) { File.expand_path('../shared/empty_script.txt', __FILE__) }

    it { is_expected.to be_empty }
  end

  context 'conflicting script (lower case)' do
    let(:file_path) { File.expand_path('../shared/lower_case_script.txt', __FILE__) }

    let(:commands) do
      [
        Colors::Commands::Init.new(rows: 10, columns: 10, line: 1),
        Colors::Commands::Pixel.new(row: 1, column: 1, color: :pink, line: 2),
        Colors::Commands::Clear.new(line: 3),
        Colors::Commands::Show.new(line: 4)
      ]
    end

    it { is_expected.to eq(commands) }
  end

  context 'conflicting script (syntax vs semantics)' do
    let(:file_path) { File.expand_path('../shared/invalid_semantics_init.txt', __FILE__) }

    let(:commands) do
      [
        Colors::Commands::Pixel.new(row: 1, column: 1, color: :pink, line: 1),
        Colors::Commands::Init.new(rows: 10, columns: 10, line: 2),
        Colors::Commands::Clear.new(line: 3),
        Colors::Commands::Show.new(line: 4)
      ]
    end

    it { is_expected.to eq(commands) }
  end

  Dir[File.expand_path('../shared/wrong_arguments_*', __FILE__)].each do |file|
    context 'invalid script (wrong call)' do
      let(:file_path) { file }

      it "#{file} throws error" do
        expect { subject }.to raise_error(Colors::ParseError)
      end
    end
  end

  Dir[File.expand_path('../shared/boundaries_check*', __FILE__)].each do |file|
    context 'invalid script (wrong call)' do
      let(:file_path) { file }

      it "#{file} throws error" do
        expect { subject }.to raise_error(Colors::ParseError)
      end
    end
  end
end
