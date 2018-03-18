module VendingMachine
  class Runner

    def initialize(vending_machine, console_selector)
      @vending_machine = vending_machine
      @console_selector = console_selector
    end

    def start_machine
      while true
        selection = @console_selector.starting_selection
        return if selection == 'exit'
        handle_selection(selection)
      end
    end

    def handle_selection(selection)
      all_stock = @vending_machine.get_all_stock
      all_coins = @vending_machine.get_change
      case selection
        when 'list'
          @console_selector.list_products(all_stock)
        when 'buy'
          coins_inserted = @console_selector.buy_product_selection(all_stock)
          return if coins_inserted.empty?
          @vending_machine.buy_product(coins_inserted[:product], coins_inserted[:coins])
        when 'reload-products'
          reload_product_selection = @console_selector.reload_product_selection(all_stock)
          return if reload_product_selection.empty?
          @vending_machine.add_stock({reload_product_selection[:product] => reload_product_selection[:amount]})
        else 'top-up-change'
          reload_coin_selection = @console_selector.reload_change_selection(all_coins)
          return if reload_coin_selection.empty?
          @vending_machine.top_up_coins(reload_coin_selection[:coin], reload_coin_selection[:amount])
      end
    end

  end
end
