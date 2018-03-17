#!/usr/bin/env ruby
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require 'vending_machine'
require 'inventory'
require 'product'
require 'coin'
require 'payment_processor'
require 'tty-prompt'

def get_price_formatted(product)
  formatted_price = product.price >= 100 ? "£#{product.price / 100}" : "#{product.price}p"
  "#{product.name}: #{formatted_price}"
end

def print_product(products)
  products.map {|product|
    get_price_formatted(product)
  }
end

accepted_coins = [VendingMachine::Coin.new('£1'),
                  VendingMachine::Coin.new('£2'),
                  VendingMachine::Coin.new('20p'),
                  VendingMachine::Coin.new('10p'),
                  VendingMachine::Coin.new('1p')]

coins = {
    VendingMachine::Coin.new('£1') => 3,
    VendingMachine::Coin.new('£2') => 2,
    VendingMachine::Coin.new('20p') => 3,
    VendingMachine::Coin.new('10p') => 4,
    VendingMachine::Coin.new('1p') => 5
}

stock = {
    VendingMachine::Product.new('cola', 100) => 1,
    VendingMachine::Product.new('mars', 50) => 3,
    VendingMachine::Product.new('pepsi', 50) => 1,
    VendingMachine::Product.new('water', 50) => 1
}


vending_machine = VendingMachine::Machine.new(VendingMachine::PaymentProcessor.new(coins), VendingMachine::Inventory.new(stock))

prompt = TTY::Prompt.new
choices = %w(list buy exit)

while true
  selection = prompt.enum_select('Select option', choices, default: 1)
  if selection == 'list'
    p print_product(vending_machine.get_products)
  elsif selection == 'buy'
    products = vending_machine.get_products
    print_to_select = print_product(products) << 'back'
    selection = prompt.enum_select('Selected ', print_to_select, default: 1)
    item = print_to_select.each_index.select { |index| print_to_select[index] == selection }.first

    if selection == 'back'
     next
    end

    product_to_buy = products[item]
    coins_to_insert = { }
    coins_to_select_denoms = accepted_coins.map{ |coin| coin.formatted }
    total_inserted_balance = 0
    while total_inserted_balance < product_to_buy.price
      puts "Total balance #{total_inserted_balance}p"
      selection = prompt.enum_select('Select coins', coins_to_select_denoms, default: 1)
      selection = coins_to_select_denoms.each_index.select { |index| coins_to_select_denoms[index] == selection }.first
      inserted_coin = accepted_coins[selection.to_i]
      if coins_to_insert.has_key? inserted_coin
        coins_to_insert[inserted_coin] = coins_to_insert[inserted_coin] + 1
      else
        coins_to_insert[inserted_coin] = 1
      end
      total_inserted_balance = total_inserted_balance + inserted_coin.pence
    end

    vending_machine.buy_product product_to_buy, coins_to_insert

  else
    exit
  end
end

