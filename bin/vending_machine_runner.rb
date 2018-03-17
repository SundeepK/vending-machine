#!/usr/bin/env ruby
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require 'vending_machine'
require 'inventory'
require 'product'
require 'coin'
require 'payment_processor'
require 'tty-prompt'

def get_price_formatted(product, count)
  formatted_price = product.price >= 100 ? "£#{product.price / 100}" : "#{product.price}p"
  "#{product.name}: #{formatted_price} (remaining #{count})"
end

def print_product(products, stock)
  products.map {|product|
    get_price_formatted(product, stock[product])
  }
  end

def print_coins(coins, all_coins)
  coins.map {|coin| "#{coin.formatted} (remaining #{all_coins[coin]})" }
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
choices = %w(list buy reload-products top-up-change exit)

while true
  selection = prompt.enum_select('Select option', choices, default: 1)
  if selection == 'list'
    all_stock = vending_machine.get_all_stock
    puts print_product(all_stock.keys, all_stock)
  elsif selection == 'buy'
    all_stock = vending_machine.get_all_stock
    products = all_stock.keys
    print_to_select = print_product(products, all_stock) << 'back'
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

  elsif selection == 'reload-products'
    all_stock = vending_machine.get_all_stock
    products = all_stock.keys
    print_to_select = print_product(products, all_stock) << 'back'
    selection = prompt.enum_select('Selected ', print_to_select, default: 1)
    item = print_to_select.each_index.select { |index| print_to_select[index] == selection }.first

    product_to_top_up = products[item]
    amount = prompt.ask('Provide number in range: 1-100?') { |q| q.in('1-100') }
    vending_machine.add_stock({ product_to_top_up => amount.to_i })
  elsif selection == 'top-up-change'

    all_coins = vending_machine.get_change
    coins = all_coins.keys
    print_to_select = print_coins(coins, all_coins) << 'back'
    selection = prompt.enum_select('Selected ', print_to_select, default: 1)
    item = print_to_select.each_index.select { |index| print_to_select[index] == selection }.first

    if selection == 'back'
      next
    end

    coin_to_top_up = coins[item]
    amount = prompt.ask('Provide number in range: 1-100?') { |q| q.in('1-100') }
    vending_machine.top_up_coins(coin_to_top_up, amount.to_i)
  else
    exit
  end
end

