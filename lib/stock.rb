module VendingMachine
  class Stock

    attr_accessor :@available_stock, :product

    def initialize(product, available_stock)
      @product = product
      @available_stock = available_stock
    end

  end
end
