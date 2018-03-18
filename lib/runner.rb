
module VendingMachine
  class Runner

    def initialize(vending_machine, console_selector)
      @vending_machine = vending_machine
      @console_selector = console_selector
    end

    def start_machine
      while true
        selection = @console_selector.starting_selection
        all_stock = @vending_machine.get_all_stock
        all_coins = @vending_machine.get_change

        case selection
          when 'list'
            @console_selector.list_products(all_stock)
          when 'buy'
            coins_inserted = @console_selector.buy_product_selection(all_stock)
            if !coins_inserted.empty?
              @vending_machine.buy_product(coins_inserted[:product], coins_inserted[:coins])
            end
          when 'reload-products'
            reload_product_selection = @console_selector.reload_product_selection(all_stock)
            if !reload_product_selection.empty?
              @vending_machine.add_stock({reload_product_selection[:product] => reload_product_selection[:amount]})
            end
          when 'top-up-change'
            reload_selection = @console_selector.reload_change_selection(all_coins)
            if !reload_selection.empty?
              @vending_machine.top_up_coins(reload_selection[:coin], reload_selection[:amount])
            end
          else
            return {}
        end

      end
    end

  end
end
