require_relative 'payment_processor'
require_relative 'coin'
require_relative 'inventory'

module VendingMachine
  class Machine

    def initialize(payment_processor: VendingMachine::PaymentProcessor.new({}), inventory: VendingMachine::Inventory.new({}))
      @payment_processor = payment_processor
      @inventory = inventory
    end

    def list_products
      @inventory.list
    end

    def get_product(name)
      @inventory.get_product name
    end

    def buy_product(name, coins)
      product = @inventory.get_product name
      if @inventory.has_stock? product
        @payment_processor.take_payment coins, product
        @inventory.remove product
        product
      end
    end
  end

end
