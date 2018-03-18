require_relative '../lib/console_selector'
require 'tty-prompt'

RSpec.describe VendingMachine::ConsoleSelector do

  coins = {
      VendingMachine::Coin.new('£1') => 3,
      VendingMachine::Coin.new('£2') => 2,
      VendingMachine::Coin.new('20p') => 3,
      VendingMachine::Coin.new('10p') => 4,
      VendingMachine::Coin.new('1p') => 5
  }

  stock = {
      VendingMachine::Product.new('cola', 100) => 1,
      VendingMachine::Product.new('mars', 50) => 1,
      VendingMachine::Product.new('pepsi', 50) => 1,
      VendingMachine::Product.new('water', 50) => 1
  }

  it 'gets users selected product via prompt' do
    prompt = double(TTY::Prompt.new)
    allow(prompt).to receive(:enum_select).and_return('mars: 50p (remaining 1)')

    actual_inserted_coins = described_class.new(prompt, coins.keys).get_selected_product(stock)
    expect(actual_inserted_coins).to eql(VendingMachine::Product.new('mars', 50))
  end

  it 'return no product if users cancels selections' do
    prompt = double(TTY::Prompt.new)
    allow(prompt).to receive(:enum_select).and_return('back')

    actual_inserted_coins = described_class.new(prompt, coins.keys).get_selected_product(stock)
    expect(actual_inserted_coins).to eql(nil)
  end

  it 'gets users inserted coins via prompt when exact change is used' do
    prompt = double(TTY::Prompt.new)
    allow(prompt).to receive(:enum_select).and_return('20p', '20p', '10p')

    actual_inserted_coins = described_class.new(prompt, coins.keys).get_inserted_coins(VendingMachine::Product.new('mars', 50))
    expect(actual_inserted_coins).to eql({VendingMachine::Coin.new('20p') => 2, VendingMachine::Coin.new('10p') => 1})
  end

  it 'gets users inserted coins via prompt when more change is inserted than product price' do
    prompt = double(TTY::Prompt.new)
    allow(prompt).to receive(:enum_select).and_return('£1')

    actual_inserted_coins = described_class.new(prompt, coins.keys).get_inserted_coins(VendingMachine::Product.new('mars', 50))
    expect(actual_inserted_coins).to eql({VendingMachine::Coin.new('£1') => 1})
  end

  it 'gets users product to top up' do
    prompt = double(TTY::Prompt.new)
    allow(prompt).to receive(:enum_select).and_return('water: 50p (remaining 1)')
    allow(prompt).to receive(:ask).and_return('30')

    actual_inserted_coins = described_class.new(prompt, coins.keys).reload_product_selection(stock)
    expect(actual_inserted_coins).to eql({ product: VendingMachine::Product.new('water', 50), amount: 30 })
  end

  it 'returns empty object if no selection is made when topping up stock' do
    prompt = double(TTY::Prompt.new)
    allow(prompt).to receive(:enum_select).and_return('back')

    actual_inserted_coins = described_class.new(prompt, coins.keys).reload_product_selection(stock)
    expect(actual_inserted_coins).to eql(nil)
  end

  it 'gets users change to top up' do
    prompt = double(TTY::Prompt.new)
    allow(prompt).to receive(:enum_select).and_return('£1 (remaining 3)')
    allow(prompt).to receive(:ask).and_return('10')

    actual_inserted_coins = described_class.new(prompt, coins.keys).reload_change_selection(coins)
    expect(actual_inserted_coins).to eql({ coin: VendingMachine::Coin.new('£1'), amount: 10 })
  end

  it 'returns empty object if no selection is made when topping up change' do
    prompt = double(TTY::Prompt.new)
    allow(prompt).to receive(:enum_select).and_return('back')

    actual_inserted_coins = described_class.new(prompt, coins.keys).reload_change_selection(coins)
    expect(actual_inserted_coins).to eql(nil)
  end

end
