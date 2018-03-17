
module VendingMachine
  class Inventory
    StockNotFoundError = Class.new(StandardError)

    def initialize(stock = {})
      @product_to_stock = stock
    end

    def add_stock(products)
      products.each do |product, stock|
        if @product_to_stock.has_key?(product)
          @product_to_stock[product] = @product_to_stock[product] + stock
        else
          @product_to_stock[product]= stock
        end
      end
    end

    def list
      @product_to_stock.keys
    end

    def has_stock?(product)
      @product_to_stock.has_key? product
    end

    def get_product(name)
      @product_to_stock.find { |product, count| product.name == name }.first
    end

    def get_all_stock
      @product_to_stock.clone
    end

    def get_available_stock(name)
      has_stock? name ? @product_to_stock[name].available_stock : 0
    end

    def remove(product)
      if has_stock? product
        new_stock = @product_to_stock[product] - 1
        if new_stock == 0
          @product_to_stock.delete product
        else
          @product_to_stock[product] = new_stock
        end
      else
        raise StockNotFoundError.new("No stock found for #{product.name}")
      end
    end

  end
end
