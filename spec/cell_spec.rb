# cell_spec.rb

require './lib/cell'

describe Cell do
  let(:cell) { Cell.new }
  describe '#empty?' do
    it 'returns true if @char is empty string' do
      expect(cell.empty?).to eql(true)
    end

    it 'returns false if @char is not empty' do
      cell.fill('X')
      expect(cell.empty?).to eql(false)
    end
  end

  describe '#fill' do
    it 'sets @char if cell is empty' do
      cell.fill('X')
      expect(cell.char).to eql('X')
    end

    it 'raises an error if the cell isn\'t empty' do
      cell.fill('X')
      expect {cell.fill('O')}.to raise_error('cell already filled')
    end
  end
end