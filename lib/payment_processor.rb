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
      change_to_ret = {}
      change = inserted_total_pence - product.price
      assert_coins_inserted(inserted_total_pence, product)
      assert_enough_balance(change)
      if change > 0
        while change > 0
          coin = sorted_coins.find { |coin| change >= coin.pence }
          assert_sufficient_coins(coin)
          change = change - coin.pence
          update_coins_to_return(coin, change_to_ret)
          current_coins[coin] = current_coins[coin] - 1
          if current_coins[coin] <= 0
            current_coins.delete coin
            sorted_coins.delete coin
          end
        end
      end
      @change = current_coins
      deposit_coins(inserted_coins)
      change_to_ret
    end

    def assert_sufficient_coins(coin)
      raise InsufficientCoins.new('Not enough coins to return change.') if coin.nil?
    end

    def update_coins_to_return(coin, coins_to_ret)
      coins_to_ret[coin] = coins_to_ret.has_key?(coin) ? coins_to_ret[coin] + 1 : 1
    end

    def assert_enough_balance(change)
      raise InsufficientBalance.new('Not enough balance in Vending to return change.') if @balance_in_pence < change
    end

    def assert_coins_inserted(total_inserted, product)
      raise InsufficientCoins.new('Not enough coins inserted') if total_inserted < product.price
    end

    def deposit_coins(coins)
      coins.each { |coin, count| @change[coin] = @change.has_key?(coin) ? @change[coin] + count : count }
      @balance_in_pence = sum_coins_pence(@change)
    end

  end
end
