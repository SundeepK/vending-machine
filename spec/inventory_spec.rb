require_relative "../lib/product"
require_relative "../lib/inventory"

RSpec.describe VendingMachine::Inventory do

  it 'adds stock' do
    stock = {
        VendingMachine::Product.new('cola', 100) => 1,
        VendingMachine::Product.new('mars', 50) => 3
    }
    expected_stock = {
        VendingMachine::Product.new('cola', 100) => 1,
        VendingMachine::Product.new('mars', 50) => 3,
        VendingMachine::Product.new('pepsi', 50) => 1,
        VendingMachine::Product.new('water', 50) => 1
    }
    under_test = described_class.new(stock)
    under_test.add_stock({VendingMachine::Product.new('pepsi', 50) => 1, VendingMachine::Product.new('water', 50) => 1})
    expect(under_test.get_all_stock).to eq(expected_stock)
  end

  it 'removes stock' do
    stock = {
        VendingMachine::Product.new('cola', 100) => 1,
        VendingMachine::Product.new('mars', 50) => 3
    }
    expected_stock = {
        VendingMachine::Product.new('cola', 100) => 1,
        VendingMachine::Product.new('mars', 50) => 2
    }
    under_test = described_class.new(stock)
    under_test.remove(VendingMachine::Product.new('mars', 50))
    expect(under_test.get_all_stock).to eq(expected_stock)
  end

  it 'removes stock completely when no more is left' do
    stock = {
        VendingMachine::Product.new('cola', 100) => 1
    }
    under_test = described_class.new(stock)
    under_test.remove(VendingMachine::Product.new('cola', 100))
    expect(under_test.get_all_stock).to eq({})
  end

  it 'throws when product not found' do
    stock = {
        VendingMachine::Product.new('cola', 100) => 1,
        VendingMachine::Product.new('mars', 50) => 3
    }

    under_test = described_class.new(stock)

    expect {under_test.remove(VendingMachine::Product.new('pepsi', 50))}
        .to raise_error(VendingMachine::Inventory::StockNotFoundError)
  end

  it 'lists stock' do
    stock = {
        VendingMachine::Product.new('cola', 100) => 1,
        VendingMachine::Product.new('mars', 50) => 3
    }

    under_test = described_class.new(stock)

    expect(under_test.list).to eq([VendingMachine::Product.new('cola', 100), VendingMachine::Product.new('mars', 50)])
  end


end
