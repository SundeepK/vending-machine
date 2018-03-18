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

    def buy_product_selection(all_stock)
      products = all_stock.keys
      print_to_select = print_product(products, all_stock) << 'back'
      selection = @prompt.enum_select('Selected ', print_to_select, default: 1)
      item = print_to_select.each_index.select { |index| print_to_select[index] == selection }.first

      if selection == 'back'
        return {}
      end

      product_to_buy = products[item]
      coins_to_insert = { }
      coins_to_select_denoms = @accepted_coins.map{ |coin| coin.formatted }
      total_inserted_balance = 0
      while total_inserted_balance < product_to_buy.price
        puts "Total balance #{total_inserted_balance}p"
        selection = @prompt.enum_select('Select coins', coins_to_select_denoms, default: 1)
        selection = coins_to_select_denoms.each_index.select { |index| coins_to_select_denoms[index] == selection }.first
        inserted_coin = @accepted_coins[selection.to_i]
        if coins_to_insert.has_key? inserted_coin
          coins_to_insert[inserted_coin] = coins_to_insert[inserted_coin] + 1
        else
          coins_to_insert[inserted_coin] = 1
        end
        total_inserted_balance = total_inserted_balance + inserted_coin.pence
      end
      {product: product_to_buy, coins: coins_to_insert}
    end

    def reload_product_selection(all_stock)
      products = all_stock.keys
      print_to_select = print_product(products, all_stock) << 'back'
      selection = @prompt.enum_select('Selected ', print_to_select, default: 1)
      item = print_to_select.each_index.select { |index| print_to_select[index] == selection }.first

      if selection == 'back'
        return {}
      end

      product_to_top_up = products[item]
      amount = @prompt.ask('Provide number in range: 1-100?') { |q| q.in('1-100') }
      {product: product_to_top_up, amount: amount.to_i}
    end

    def reload_change_selection(all_coins)
      coins = all_coins.keys
      print_to_select = print_coins(coins, all_coins) << 'back'
      selection = @prompt.enum_select('Selected ', print_to_select, default: 1)
      item = print_to_select.each_index.select { |index| print_to_select[index] == selection }.first

      if selection == 'back'
        return {}
      end

      coin_to_top_up = coins[item]
      amount = @prompt.ask('Provide number in range: 1-100?') { |q| q.in('1-100') }
      { coin: coin_to_top_up, amount: amount.to_i}
    end


  end
end