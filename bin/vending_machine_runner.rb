#!/usr/bin/env ruby
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require 'vending_machine'
require 'inventory'
require 'product'
require 'coin'
require 'console_selector'
require 'payment_processor'
require 'tty-prompt'
require 'runner'

coins = {
    VendingMachine::Coin.new('£1') => 1,
    VendingMachine::Coin.new('£2') => 1,
    VendingMachine::Coin.new('20p') => 1,
    VendingMachine::Coin.new('10p') => 1,
    VendingMachine::Coin.new('1p') => 1
}

stock = {
    VendingMachine::Product.new('cola', 100) => 1,
    VendingMachine::Product.new('mars', 50) => 1,
    VendingMachine::Product.new('pepsi', 50) => 1,
    VendingMachine::Product.new('water', 50) => 1,
    VendingMachine::Product.new('lollipop', 1) => 1
}

vending_machine = VendingMachine::Machine.new(VendingMachine::PaymentProcessor.new(coins), VendingMachine::Inventory.new(stock))
console_selector = VendingMachine::ConsoleSelector.new(TTY::Prompt.new, coins.keys)

runner = VendingMachine::Runner.new(vending_machine, console_selector)
runner.start_machine
