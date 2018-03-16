#!/usr/bin/env ruby

require 'vending_machine'
require 'inventory'
require 'product'
require 'coin'
require 'payment_processor'

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



