RSpec.describe Colors::SemanticChecker do
  let(:instance) { described_class.new }
  subject { instance.check(commands)   }

  context 'not initialized board' do
    let(:commands) do
      [
        Colors::Commands::Pixel.new(row: 1, column: 1, color: :black, line: 1)
      ]
    end

    it { is_expected.to include(errors: ['Not initialized board to paint on. (L:1)'])}
  end

  context 'useless lines (not show command)' do
    let(:commands) do
      [
        Colors::Commands::Init.new(rows: 10, columns: 10, line: 1),
        Colors::Commands::Pixel.new(row: 1, column: 1, color: :black, line: 2)
      ]
    end

    let(:init_warnings)  { subject[0][:warnings] }
    let(:pixel_warnings) { subject[1][:warnings] }

    it { expect(init_warnings).to include('Ignoring extra line; missing show command afterwards. (L:1)') }
    it { expect(pixel_warnings).to include('Ignoring extra line; missing show command afterwards. (L:2)') }
  end

  context 'out of boundaries errors (vertical_line)' do
    let(:commands) do
      [
        Colors::Commands::Init.new(rows: 10, columns: 10, line: 1),
        Colors::Commands::VerticalLine.new(start_row: 11, end_row: 13, color: :black, column: 13, line: 2),
        Colors::Commands::Show.new(line: 3)
      ]
    end

    let(:errors) { subject[1][:errors] }

    it { expect(errors).to include('Incorrect value for start_row (11), it should be between 1 and 10. (L:2)') }
    it { expect(errors).to include('Incorrect value for end_row (13), it should be between 1 and 10. (L:2)')   }
    it { expect(errors).to include('Incorrect value for column (13), it should be between 1 and 10. (L:2)')    }
    it { expect(errors.length).to eq(3)  }
    it { expect(subject.first).to be_nil }
  end

  context 'out of boundaries errors (horizontal_line)' do
    let(:commands) do
      [
        Colors::Commands::Init.new(rows: 10, columns: 10, line: 1),
        Colors::Commands::HorizontalLine.new(start_column: 2, end_column: 13, color: :black, row: 10, line: 2),
        Colors::Commands::Show.new(line: 3)
      ]
    end

    let(:errors) { subject[1][:errors] }

    it { expect(errors).to include('Incorrect value for end_column (13), it should be between 1 and 10. (L:2)')   }
    it { expect(errors.length).to eq(1)  }
    it { expect(subject.first).to be_nil }
  end

  context 'valid program' do
    let(:commands) do
      [
        Colors::Commands::Init.new(rows: 10, columns: 10, line: 1),
        Colors::Commands::HorizontalLine.new(start_column: 2, end_column: 3, color: :black, row: 10, line: 2),
        Colors::Commands::Show.new(line: 3)
      ]
    end

    it { expect(subject.compact).to be_empty }
  end

  context 'valid program (double show)' do
    let(:commands) do
      [
        Colors::Commands::Init.new(rows: 10, columns: 10, line: 1),
        Colors::Commands::HorizontalLine.new(start_column: 2, end_column: 3, color: :black, row: 10, line: 2),
        Colors::Commands::Show.new(line: 3),
        Colors::Commands::VerticalLine.new(column: 2, start_row: 3, end_row: 2, color: :black, line: 4),
        Colors::Commands::Show.new(line: 5)
      ]
    end

    it { expect(subject.compact).to be_empty }
  end

  context 'valid program (double init)' do
    let(:commands) do
      [
        Colors::Commands::Init.new(rows: 10, columns: 10, line: 1),
        Colors::Commands::Pixel.new(row: 1, column: 1, color: :black, line: 2),
        Colors::Commands::Show.new(line: 3),
        Colors::Commands::Init.new(rows: 10, columns: 10, line: 4),
        Colors::Commands::Pixel.new(row: 1, column: 1, color: :black, line: 5),
        Colors::Commands::Show.new(line: 6)
      ]
    end

    it { expect(subject.compact).to be_empty }
  end

  context 'valid program with warnings (double init)' do
    let(:commands) do
      [
        Colors::Commands::Init.new(rows: 10, columns: 10, line: 1),
        Colors::Commands::Pixel.new(row: 1, column: 1, color: :black, line: 2),
        Colors::Commands::Init.new(rows: 10, columns: 10, line: 3),
        Colors::Commands::Pixel.new(row: 1, column: 1, color: :black, line: 4),
        Colors::Commands::Show.new(line: 5)
      ]
    end

    let(:init_warnings) { subject[0][:warnings] }
    let(:pixel_warnings) { subject[1][:warnings] }

    it { expect(init_warnings).to include('Ignoring line due to board overwrite on line 3. (L:1)')  }
    it { expect(init_warnings.length).to eq(1)  }

    it { expect(pixel_warnings).to include('Ignoring line due to board overwrite on line 3. (L:2)') }
    it { expect(pixel_warnings.length).to eq(1) }

    it { expect(subject.drop(2).compact).to be_empty }
  end

  context 'valid program with warnings (clear)' do
    let(:commands) do
      [
        Colors::Commands::Init.new(rows: 10, columns: 10, line: 1),
        Colors::Commands::Pixel.new(row: 1, column: 1, color: :black, line: 2),
        Colors::Commands::Clear.new(line: 3),
        Colors::Commands::Pixel.new(row: 1, column: 1, color: :black, line: 4),
        Colors::Commands::Show.new(line: 5)
      ]
    end

    let(:init_warnings) { subject[0] }
    let(:pixel_warnings) { subject[1][:warnings] }

    it { expect(init_warnings).to be_nil }

    it { expect(pixel_warnings).to include('Ignoring line due to clear overwrite on line 3. (L:2)') }
    it { expect(pixel_warnings.length).to eq(1) }

    it { expect(subject.drop(2).compact).to be_empty }
  end
end
