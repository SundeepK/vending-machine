require 'pry'
require 'set'

module VendingMachine
  class PaymentProcessor
    InsufficientBalance = Class.new(StandardError)
    InsufficientCoins = Class.new(StandardError)

    attr_accessor :balance_in_pence

    def initialize(coins_to_count = {})
      @change = coins_to_count
      @balance_in_pence = sum_coins_pence(coins_to_count)
    end

    def sum_coins_pence(coins_to_count)
      coins_to_count.map {|coin, count| coin.pence * count}.sum
    end

    def add_coin(coin, num_of_coins)
      @change[coin] = @change.has_key?(coin) ? @change[coin] + num_of_coins : num_of_coins
    end

    def get_coins
      @change.clone
    end

    def take_payment(inserted_coins, product)
      current_coins = @change.clone
      sorted_coins = Set.new(current_coins.keys.sort { |a,b| b.pence <=> a.pence })
      inserted_total_pence = sum_coins_pence(inserted_coins)
      coins_to_ret = {}
      change = inserted_total_pence - product.price
      assert_coins_inserted(inserted_total_pence, product)
      assert_enough_balance(change)
      if change > 0
        while change > 0
          coin = sorted_coins.find { |coin| change >= coin.pence }
          assert_sufficient_coins(coin)
          change = change - coin.pence
          update_coins_to_return(coin, coins_to_ret)
          current_coins[coin] = current_coins[coin] - 1
          if current_coins[coin] <= 0
            current_coins.delete coin
            sorted_coins.delete coin
          end
        end
      end
      @change = current_coins
      deposit_coins(inserted_coins)
      coins_to_ret
    end

    def assert_sufficient_coins(coin)
      if coin.nil?
        raise InsufficientCoins.new('Not enough coins to return change.')
      end
    end

    def update_coins_to_return(coin, coins_to_ret)
      if coins_to_ret.has_key? coin
        coins_to_ret[coin] = coins_to_ret[coin] + 1
      else
        coins_to_ret[coin] = 1
      end
    end

    def assert_enough_balance(change)
      if @balance_in_pence < change
        raise InsufficientBalance.new('Not enough balance in Vending to return change.')
      end
    end

    def assert_coins_inserted(total_inserted, product)
      if total_inserted < product.price
        raise InsufficientCoins.new('Not enough coins inserted')
      end
    end

    def deposit_coins(coins)
      coins.each do |coin, count|
        if @change.has_key? coin
          @change[coin] = @change[coin] + count
        else
          @change[coin] = count
        end
      end
      @balance_in_pence = sum_coins_pence(@change)
    end

  end
end
