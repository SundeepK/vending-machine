require_relative 'payment_processor'
require_relative 'coin'
require_relative 'inventory'

module VendingMachine
  class Machine

    def initialize(payment_processor = VendingMachine::PaymentProcessor.new({}), inventory = VendingMachine::Inventory.new({}))
      @payment_processor = payment_processor
      @inventory = inventory
    end

    def get_products
      @inventory.list.clone
    end

    def get_product(name)
      @inventory.get_product name
    end

    def buy_product(product, coins)
      product = @inventory.get_product product.name
      if @inventory.has_stock? product
        puts "found product #{product.name} in stock"
        vend(coins, product)
      end
    end

    def vend(coins, product)
      begin
        change = @payment_processor.take_payment coins, product
        @inventory.remove product
        print_change(change, product)
      rescue TypeError, NameError => e
        puts "#{e.message}"
      end
      change
    end

    def print_change(change, product)
      changed_formatted = change.map {|coin, count| "#{coin.formatted} x #{count}"}.join(", ")
      puts "#{product.name} is dispensed enjoy!"
      if changed_formatted.size > 0
        puts "Found change #{changed_formatted}"
      else
        puts 'No change returned'
      end
    end
  end

end
