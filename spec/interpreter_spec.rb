RSpec.describe Colors::Interpreter do
  let(:instance) { described_class.new }

  context 'executes init' do
    let(:commands) do
      [
        Colors::Commands::Init.new(rows: 2, columns: 2, line: 1)
      ]
    end

    let(:semantic_results) { [nil] }

    before { instance.execute(commands, semantic_results) }
    #                                  [1,1]   [1,2]   [2,1]   [2,2]
    it { expect(instance.data).to eq([:white, :white, :white, :white]) }
  end

  context 'executes show' do
    let(:commands) do
      [
        Colors::Commands::Init.new(rows: 2, columns: 2, line: 1),
        Colors::Commands::Show.new(line: 2)
      ]
    end

    let(:semantic_results) { [nil, nil] }

    before do
      expect(Kernel).to receive(:print).exactly(6).times.and_return('OK')
    end

    it { instance.execute(commands, semantic_results) }
  end

  context 'executes clear' do
    let(:commands) do
      [
        Colors::Commands::Init.new(rows: 2, columns: 2, line: 1),
        Colors::Commands::Pixel.new(row: 1, column: 1, color: :pink, line: 2),
        Colors::Commands::Clear.new(line: 2)
      ]
    end

    let(:semantic_results) { [nil, nil, nil] }

    before { instance.execute(commands, semantic_results) }

    it { expect(instance.data[0]).to eq(:white) }
  end

  context 'executes pixel' do
    let(:commands) do
      [
        Colors::Commands::Init.new(rows: 2, columns: 2, line: 1),
        Colors::Commands::Pixel.new(row: 1, column: 1, color: :pink, line: 2)
      ]
    end

    let(:semantic_results) { [nil, nil] }

    before { instance.execute(commands, semantic_results) }

    it { expect(instance.data[0]).to eq(:pink) }
  end

  context 'executes vertical_line' do
    let(:commands) do
      [
        Colors::Commands::Init.new(rows: 2, columns: 2, line: 1),
        Colors::Commands::VerticalLine.new(start_row: 1, end_row: 2, color: :pink, column: 2, line: 2)
      ]
    end

    let(:semantic_results) { [nil, nil] }

    before { instance.execute(commands, semantic_results) }

    it { expect(instance.data[0]).to eq(:white) }
    it { expect(instance.data[1]).to eq(:pink) }
    it { expect(instance.data[2]).to eq(:white) }
    it { expect(instance.data[3]).to eq(:pink) }
  end

  context 'executes horizontal_line' do
    let(:commands) do
      [
        Colors::Commands::Init.new(rows: 2, columns: 2, line: 1),
        Colors::Commands::HorizontalLine.new(start_column: 1, end_column: 2, color: :pink, row: 2, line: 2)
      ]
    end

    let(:semantic_results) { [nil, nil] }

    before { instance.execute(commands, semantic_results) }

    it { expect(instance.data[0]).to eq(:white) }
    it { expect(instance.data[1]).to eq(:white) }
    it { expect(instance.data[2]).to eq(:pink) }
    it { expect(instance.data[3]).to eq(:pink) }
  end

  context 'reads errors before and stop' do
    let(:commands) do
      [
        Colors::Commands::Init.new(rows: 2, columns: 2, line: 1),
        Colors::Commands::HorizontalLine.new(start_column: 1, end_column: 2, color: :pink, row: 2, line: 2)
      ]
    end

    let(:error) do
      { errors: ['foo'] }
    end

    let(:semantic_results) { [nil, error] }


    it 'throws error' do
      expect { instance.execute(commands, semantic_results) }.to raise_error(Colors::RuntimeError)
    end
  end

  context 'reads warnings and continues' do
    let(:commands) do
      [
        Colors::Commands::Init.new(rows: 2, columns: 2, line: 1),
        Colors::Commands::Init.new(rows: 3, columns: 3, line: 1),
      ]
    end

    let(:warning) do
      { warnings: ['foo'] }
    end

    let(:semantic_results) { [nil, warning] }

    before do
      expect(Kernel).to receive(:puts).once
      instance.execute(commands, semantic_results)
    end

    it { expect(instance.data).to eq([:white, :white, :white, :white]) }
  end
end
