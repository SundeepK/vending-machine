require 'set'

module VendingMachine
  class Coin
    COINS = Set[1, 2, 5, 10, 20, 50, 100, 200]

    :pence

    def initialize(value)
      if value.start_with? '£'
        @pence = value.gsub(/£/, '').to_i * 100
      elsif value.end_with? 'p'
        pence = value.gsub(/p/, '').to_i
        @pence = pence < 100 ? pence : 0
      else
        @pence = 0
      end
    end

    def is_valid?
      COINS.include?(@pence)
    end

    def pence
      if is_valid?
        @pence
      else
        0
      end
    end

    def ==(o)
      o.class == self.class && o.state == state
    end

    def formatted
      if is_valid?
        @pence >= 100 ? "£#{(@pence/ 100)}" : "#{@pence}p"
      else
        '0p'
      end
    end

    protected

    def state
      [@pence]
    end

    alias_method :eql?, :==

    def hash
      state.hash
    end

  end
end
