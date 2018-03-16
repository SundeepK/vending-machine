require "vending_machine/version"

module VendingMachine
  class Product
    attr_reader :name, :price

    def initialize(name, price)
      @name = name
      @price = price
    end
  end
end
