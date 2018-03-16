require_relative 'stock'

module VendingMachine
  class Inventory
    OutOfStockError = Class.new(StandardError)

    def initialize(stock = [])
      @product_to_stock = stock.map {|s| [s.product.name, s]}.to_h
    end

    def add_stock(stock_to_add)
      stock_to_add.each do |stock|
        product_name = stock.product.name
        if @product_to_stock.has_key?(product_name)
          @product_to_stock[stock.product] = Stock.new(stock, stock.available_stock + @product_to_stock[product_name].available_stock)
        else
          @product_to_stock[stock.product]= stock
        end
      end
    end

    def list
      @product_to_stock.keys
    end

    def has_stock?(name)
      @product_to_stock.has_key? name
    end

    def get_available_stock(name)
      has_stock? name ? @product_to_stock[name].available_stock : 0
    end

    def remove(name)
      if has_stock? name
        new_stock = @product_to_stock[name].available_stock
        if new_stock == 0
          @product_to_stock.delete name
        else
          @product_to_stock[name] = Stock.new(name, new_stock)
        end
      else
        raise OutOfStockError.new("No stock found for #{name}")
      end
    end

  end
end
