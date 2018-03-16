require_relative "../lib/coin"
require_relative "../lib/../lib/payment_processor"
require_relative "../lib/../lib/../lib/product"


RSpec.describe VendingMachine::PaymentProcessor do

  vending_machine_coins = {
      VendingMachine::Coin.new('£1') => 2,
      VendingMachine::Coin.new('£2') => 2,
      VendingMachine::Coin.new('20p') => 5,
      VendingMachine::Coin.new('10p') => 5,
      VendingMachine::Coin.new('1p') => 2
  }

  it 'returns change' do
    payment_processor = described_class.new(vending_machine_coins)

    expected_change = {
        VendingMachine::Coin.new('20p') => 2,
        VendingMachine::Coin.new('10p') => 1,
    }

    expected_vending_machine_coins = {
        VendingMachine::Coin.new('£1') => 3,
        VendingMachine::Coin.new('£2') => 2,
        VendingMachine::Coin.new('20p') => 3,
        VendingMachine::Coin.new('10p') => 4,
        VendingMachine::Coin.new('1p') => 2
    }

    payment_coins = {
        VendingMachine::Coin.new('£1') => 1
    }

    actual_change = payment_processor.take_payment(payment_coins, VendingMachine::Product.new('Cola', 50))
    expect(actual_change).to eq(expected_change)
    expect(payment_processor.get_coins).to eq(expected_vending_machine_coins)
  end

  it 'returns no change when exact amount is payed' do
    payment_processor = described_class.new(vending_machine_coins)

    expected_vending_machine_coins = {
        VendingMachine::Coin.new('£1') => 2,
        VendingMachine::Coin.new('£2') => 2,
        VendingMachine::Coin.new('20p') => 7,
        VendingMachine::Coin.new('10p') => 6,
        VendingMachine::Coin.new('1p') => 2
    }

    payment_coins = {
        VendingMachine::Coin.new('20p') => 2,
        VendingMachine::Coin.new('10p') => 1
    }

    actual_change = payment_processor.take_payment(payment_coins, VendingMachine::Product.new('Cola', 50))
    expect(actual_change).to eq({})
    expect(payment_processor.get_coins).to eq(expected_vending_machine_coins)
  end

  it 'throws InsufficientBalance when not enough balance' do
    payment_processor = described_class.new({})

    payment_coins = {
        VendingMachine::Coin.new('20p') => 2,
        VendingMachine::Coin.new('10p') => 1
    }

    expect {payment_processor.take_payment(payment_coins, VendingMachine::Product.new('Cola', 50))}
        .to raise_error(VendingMachine::PaymentProcessor::InsufficientBalance)
  end


end
