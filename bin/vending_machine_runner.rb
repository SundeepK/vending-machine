#!/usr/bin/env ruby
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require 'vending_machine'
require 'inventory'
require 'product'
require 'coin'
require 'console_selector'
require 'payment_processor'
require 'tty-prompt'

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

prompt = TTY::Prompt.new
vending_machine = VendingMachine::Machine.new(VendingMachine::PaymentProcessor.new(coins), VendingMachine::Inventory.new(stock))
console_selector = VendingMachine::ConsoleSelector.new(prompt, coins.keys)


while true
  selection = console_selector.starting_selection
  all_stock = vending_machine.get_all_stock
  all_coins = vending_machine.get_change

  case selection
    when 'list'
      console_selector.list_products(all_stock)
    when 'buy'
      coins_inserted = console_selector.buy_product_selection(all_stock)
      if !coins_inserted.empty?
        vending_machine.buy_product(coins_inserted[:product], coins_inserted[:coins])
      end
    when 'reload-products'
      reload_product_selection = console_selector.reload_product_selection(all_stock)
      if !reload_product_selection.empty?
        vending_machine.add_stock({reload_product_selection[:product] => reload_product_selection[:amount]})
      end
    when 'top-up-change'
      reload_selection = console_selector.reload_change_selection(all_coins)
      if !reload_selection.empty?
        vending_machine.top_up_coins(reload_selection[:coin], reload_selection[:amount])
      end
    else
      exit
  end
end

