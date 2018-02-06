RSpec.describe Colors::Parser do
  let(:instance) { described_class.new }
  subject { instance.parse(file_path)  }

  context 'valid script' do
    let(:file_path) { File.expand_path('../shared/valid_script.txt', __FILE__) }
    let(:commands) do
      [
        Colors::Commands::Init.new(rows: 10, columns: 10),
        Colors::Commands::Clear.new,
        Colors::Commands::Pixel.new(row: 1, column: 3, color: :black),
        Colors::Commands::VerticalLine.new(column: 2, start_row: 1, end_row: 3, color: :white),
        Colors::Commands::HorizontalLine.new(start_col: 3, end_col: 5, row: 1, color: :pink),
        Colors::Commands::Show.new
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
        Colors::Commands::Init.new(rows: 10, columns: 10),
        Colors::Commands::VerticalLine.new(column: 1, start_row: 1, end_row: 2, color: :pink),
        Colors::Commands::Show.new
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
        Colors::Commands::Init.new(rows: 10, columns: 10),
        Colors::Commands::Pixel.new(row: 1, column: 1, color: :pink),
        Colors::Commands::Clear.new,
        Colors::Commands::Show.new
      ]
    end

    it { is_expected.to eq(commands) }
  end

  context 'conflicting script (syntax vs semantics)' do
    let(:file_path) { File.expand_path('../shared/invalid_semantics_init.txt', __FILE__) }

    let(:commands) do
      [
        Colors::Commands::Pixel.new(row: 1, column: 1, color: :pink),
        Colors::Commands::Init.new(rows: 10, columns: 10),
        Colors::Commands::Clear.new,
        Colors::Commands::Show.new
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
end
