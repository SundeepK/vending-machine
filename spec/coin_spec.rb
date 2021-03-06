require_relative "../lib/coin"

RSpec.describe VendingMachine::Coin do

  it 'accepts valid coins pence coins [1p, 2p, 5p, 10p, 20p, 50p]' do
    coins = [1, 2, 5, 10, 20, 50]
    coins.each do |coin|
      coin_formatted = "#{coin}p"
      under_test = described_class.new(coin_formatted)
      expect(under_test.pence).to eq(coin)
      expect(under_test.is_valid?).to eq(true)
      expect(under_test.formatted).to eq(coin_formatted)
    end
  end

  it 'accepts valid coins pounds coins [£1, £2]' do
    coins = [1, 2]
    coins.each do |coin|
      coin_formatted = "£#{coin}"
      under_test = described_class.new(coin_formatted)
      expect(under_test.pence).to eq(coin * 100)
      expect(under_test.is_valid?).to eq(true)
      expect(under_test.formatted).to eq(coin_formatted)
    end
  end

  it 'does not accept invalid coins [3p, 40p, 100p, 200p, 300p, 1000p]' do
    coins = [3, 40, 100, 200, 300, 1000]
    coins.each do |coin|
      coin_formatted = "#{coin}p"
      under_test = described_class.new(coin_formatted)
      expect(under_test.pence).to eq(0)
      expect(under_test.is_valid?).to eq(false)
      expect(under_test.formatted).to eq('0p')
    end
  end

  it 'returns true when compared to same object' do
    expect(described_class.new('1p') == described_class.new('1p')).to eq(true)
  end

  it 'returns false when compared to different object' do
    expect(described_class.new('10p') == described_class.new('1p')).to eq(false)
  end

end
