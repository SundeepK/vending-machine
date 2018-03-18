require_relative "../lib/coin"
require_relative "../lib/payment_processor"
require_relative "../lib/product"


RSpec.describe VendingMachine::PaymentProcessor do

  it 'returns change 1' do
    payment_processor = described_class.new(given_coins)

    expected_change = {
        VendingMachine::Coin.new('20p') => 2,
        VendingMachine::Coin.new('10p') => 1,
    }

    expected_vending_machine_coins = {
        VendingMachine::Coin.new('£1') => 3,
        VendingMachine::Coin.new('£2') => 2,
        VendingMachine::Coin.new('20p') => 3,
        VendingMachine::Coin.new('10p') => 4,
        VendingMachine::Coin.new('1p') => 5
    }

    payment_coins = {
        VendingMachine::Coin.new('£1') => 1
    }

    actual_change = payment_processor.take_payment(payment_coins, VendingMachine::Product.new('Cola', 50))
    expect(actual_change).to eq(expected_change)
    expect(payment_processor.get_coins).to eq(expected_vending_machine_coins)
  end

  it 'returns change 2' do
    payment_processor = described_class.new(given_coins)

    expected_change = {
        VendingMachine::Coin.new('10p') => 1,
    }

    expected_vending_machine_coins = {
        VendingMachine::Coin.new('£1') => 2,
        VendingMachine::Coin.new('£2') => 2,
        VendingMachine::Coin.new('20p') => 8,
        VendingMachine::Coin.new('10p') => 4,
        VendingMachine::Coin.new('1p') => 5
    }

    payment_coins = {
        VendingMachine::Coin.new('20p') => 3
    }

    actual_change = payment_processor.take_payment(payment_coins, VendingMachine::Product.new('Cola', 50))
    expect(actual_change).to eq(expected_change)
    expect(payment_processor.get_coins).to eq(expected_vending_machine_coins)
  end

  it 'returns change 3' do
    payment_processor = described_class.new(given_coins)

    expected_change = {
        VendingMachine::Coin.new('1p') => 5,
        VendingMachine::Coin.new('10p') => 1
    }

    expected_vending_machine_coins = {
        VendingMachine::Coin.new('£1') => 3,
        VendingMachine::Coin.new('£2') => 2,
        VendingMachine::Coin.new('20p') => 7,
        VendingMachine::Coin.new('10p') => 4
    }

    payment_coins = {
        VendingMachine::Coin.new('£1') => 1,
        VendingMachine::Coin.new('20p') => 2
    }

    actual_change = payment_processor.take_payment(payment_coins, VendingMachine::Product.new('mars', 125))
    expect(actual_change).to eq(expected_change)
    expect(payment_processor.get_coins).to eq(expected_vending_machine_coins)
  end

  it 'returns change 4' do
    payment_processor = described_class.new(given_coins)

    expected_change = {}

    expected_vending_machine_coins = {
        VendingMachine::Coin.new('£1') => 2,
        VendingMachine::Coin.new('£2') => 2,
        VendingMachine::Coin.new('20p') => 5,
        VendingMachine::Coin.new('10p') => 5,
        VendingMachine::Coin.new('1p') => 16
    }

    payment_coins = {
        VendingMachine::Coin.new('1p') => 11
    }

    actual_change = payment_processor.take_payment(payment_coins, VendingMachine::Product.new('bon bon', 11))
    expect(actual_change).to eq(expected_change)
    expect(payment_processor.get_coins).to eq(expected_vending_machine_coins)
  end

  it 'returns change 5' do
    coins = given_coins
    coins[VendingMachine::Coin.new('50p')] = 5
    payment_processor = described_class.new(coins)

    expected_change = {}

    expected_vending_machine_coins = {
        VendingMachine::Coin.new('£1') => 2,
        VendingMachine::Coin.new('£2') => 126,
        VendingMachine::Coin.new('50p') => 9,
        VendingMachine::Coin.new('20p') => 5,
        VendingMachine::Coin.new('10p') => 5,
        VendingMachine::Coin.new('1p') => 5
    }

    payment_coins = {
        VendingMachine::Coin.new('£2') => 124,
        VendingMachine::Coin.new('50p') => 4
    }

    actual_change = payment_processor.take_payment(payment_coins, VendingMachine::Product.new('lambo', 25000))
    expect(actual_change).to eq(expected_change)
    expect(payment_processor.get_coins).to eq(expected_vending_machine_coins)
  end

  it 'returns change for 99p product' do
    payment_processor = described_class.new(given_coins)

    expected_change = {VendingMachine::Coin.new('1p') => 1}

    expected_vending_machine_coins = {
        VendingMachine::Coin.new('£1') => 3,
        VendingMachine::Coin.new('£2') => 2,
        VendingMachine::Coin.new('20p') => 5,
        VendingMachine::Coin.new('10p') => 5,
        VendingMachine::Coin.new('1p') => 4
    }

    payment_coins = {
        VendingMachine::Coin.new('£1') => 1,
    }

    actual_change = payment_processor.take_payment(payment_coins, VendingMachine::Product.new('Zero point gravity gun', 99))
    expect(actual_change).to eq(expected_change)
    expect(payment_processor.get_coins).to eq(expected_vending_machine_coins)
  end

  it 'handles case where vending machine has just enough change' do
    coins = {
        VendingMachine::Coin.new('£1') => 1
    }
    payment_processor = described_class.new(coins)

    actual_change = payment_processor.take_payment({ VendingMachine::Coin.new('£2') => 1 }, VendingMachine::Product.new('mars', 100))

    expect(actual_change).to eq(VendingMachine::Coin.new('£1') => 1)
    expect(payment_processor.get_coins).to eq(VendingMachine::Coin.new('£2') => 1)
  end


  it 'returns no change when exact amount is payed' do
    payment_processor = described_class.new(given_coins)

    expected_vending_machine_coins = {
        VendingMachine::Coin.new('£1') => 2,
        VendingMachine::Coin.new('£2') => 2,
        VendingMachine::Coin.new('20p') => 7,
        VendingMachine::Coin.new('10p') => 6,
        VendingMachine::Coin.new('1p') => 5
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
        VendingMachine::Coin.new('20p') => 3
    }

    expect {payment_processor.take_payment(payment_coins, VendingMachine::Product.new('Cola', 50))}
        .to raise_error(VendingMachine::PaymentProcessor::InsufficientBalance)
  end

  it 'throws InsufficientCoins when not enough coins inserted' do
    payment_processor = described_class.new({})

    payment_coins = {
        VendingMachine::Coin.new('10p') => 1
    }

    expect {payment_processor.take_payment(payment_coins, VendingMachine::Product.new('Cola', 50))}
        .to raise_error(VendingMachine::PaymentProcessor::InsufficientCoins)
  end

  it 'throws InsufficientCoins when vending machine does not have enough coins' do
    vending_machine_coins = {
        VendingMachine::Coin.new('£1') => 2,
        VendingMachine::Coin.new('1p') => 2
    }
    payment_processor = described_class.new(vending_machine_coins)

    payment_coins = {
        VendingMachine::Coin.new('£1') => 1
    }

    expect {payment_processor.take_payment(payment_coins, VendingMachine::Product.new('Cola', 50))}
        .to raise_error(VendingMachine::PaymentProcessor::InsufficientCoins)
    expect(payment_processor.get_coins).to eq(vending_machine_coins)

  end

  def given_coins
     {
        VendingMachine::Coin.new('£1') => 2,
        VendingMachine::Coin.new('£2') => 2,
        VendingMachine::Coin.new('20p') => 5,
        VendingMachine::Coin.new('10p') => 5,
        VendingMachine::Coin.new('1p') => 5
    }
  end
end
