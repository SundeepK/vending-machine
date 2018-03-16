require "vending_machine/version"

module VendingMachine
  class Product
    attr_reader :name, :price

    def initialize(name, price)
      @name = name
      @price = price
    end

    def ==(o)
      o.class == self.class && o.state == state
    end

    protected

    def state
      [@name, @price]
    end

    alias_method :eql?, :==

    def hash
      state.hash
    end

  end
end
