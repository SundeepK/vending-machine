require 'vending_machine'
require 'inventory'
require 'product'
require 'coin'
require 'payment_processor'
require 'tty-prompt'

module VendingMachine
  class ConsoleSelector

    STARTING_SELECTION = %w(list buy reload-products top-up-change exit)

    def initialize(prompt, accepted_coins)
      @prompt = prompt
      @accepted_coins = accepted_coins
    end

    def print_coins(coins, all_coins)
      coins.map {|coin| "#{coin.formatted} (remaining #{all_coins[coin]})" }
    end

    def get_price_formatted(product, count)
      formatted_price = product.price >= 100 ? "£#{product.price / 100}" : "#{product.price}p"
      "#{product.name}: #{formatted_price} (remaining #{count})"
    end

    def print_product(products, stock)
      products.map {|product| get_price_formatted(product, stock[product])}
    end

    def list_products(all_stock)
      puts print_product(all_stock.keys, all_stock)
    end

    def starting_selection
      @prompt.enum_select('Select option', STARTING_SELECTION, default: 1)
    end

    def get_selected_product(all_stock)
      products = all_stock.keys
      print_to_select = print_product(products, all_stock) << 'back'
      selection = @prompt.enum_select('Selected ', print_to_select, default: 1)
      item = print_to_select.each_index.select { |index| print_to_select[index] == selection }.first
      return nil if selection == 'back'

      products[item]
    end

    def get_inserted_coins(product_to_buy)
      inserted_coins = { }
      accepted_coins_prices = @accepted_coins.map{ |coin| coin.formatted }
      total_inserted_balance = 0
      while total_inserted_balance < product_to_buy.price
        puts "Total inserted balance #{total_inserted_balance}p"
        selection = @prompt.enum_select('Select coins', accepted_coins_prices, default: 1)
        selection = accepted_coins_prices.each_index.select { |index| accepted_coins_prices[index] == selection }.first
        inserted_coin = @accepted_coins[selection.to_i]
        inserted_coins[inserted_coin] = inserted_coins.has_key?(inserted_coin) ? inserted_coins[inserted_coin] + 1 : 1
        total_inserted_balance = total_inserted_balance + inserted_coin.pence
      end
      inserted_coins
    end

    def reload_product_selection(all_stock)
      products = all_stock.keys
      print_to_select = print_product(products, all_stock) << 'back'
      selection = @prompt.enum_select('Selected ', print_to_select, default: 1)
      item = print_to_select.each_index.select { |index| print_to_select[index] == selection }.first

      return nil if selection == 'back'

      amount = @prompt.ask('Provide number in range: 1-100?') { |q| q.in('1-100') }.to_i
      {product: products[item], amount: amount}
    end

    def reload_change_selection(all_coins)
      coins = all_coins.keys
      print_to_select = print_coins(coins, all_coins) << 'back'
      selection = @prompt.enum_select('Selected ', print_to_select, default: 1)
      item = print_to_select.each_index.select { |index| print_to_select[index] == selection }.first
      return nil if selection == 'back'

      amount = @prompt.ask('Provide number in range: 1-100?') { |q| q.in('1-100') }.to_i
      { coin: coins[item], amount: amount}
    end


  end
end