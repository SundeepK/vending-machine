require_relative "../lib/product"

RSpec.describe VendingMachine::Product do

  it 'returns true when compared to same object' do
    expect(described_class.new('cola', 50) == described_class.new('cola', 50)).to eq(true)
    expect({ described_class.new('cola', 50) => 1 }  == { described_class.new('cola', 50) => 1} ).to eq(true)
  end

  it 'returns false when compared to different object' do
    expect(described_class.new('cola', 50) == described_class.new('pepsi', 50)).to eq(false)
  end

end
