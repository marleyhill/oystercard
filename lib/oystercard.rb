class Oystercard
  attr_accessor :balance
  attr_reader :entry_station
  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1

  def initialize
    @balance = 0
  end

  def in_journey?
    @entry_station
  end

  def touch_in(station = "test station")
    @entry_station = station
    fail "Insufficient balance" if minimum_balance?
    # @in_journey = true
  end

  def touch_out
    # @in_journey = false
    @entry_station = nil
    deduct(MINIMUM_BALANCE)
  end

  def top_up(amount)
    @amount = amount
    fail "Maximum balance of #{MAXIMUM_BALANCE} exceeded" if over_balance?
    @balance += amount
  end

  private
  def over_balance?
    @amount + @balance > MAXIMUM_BALANCE
  end

  def minimum_balance?
    @balance < MINIMUM_BALANCE
  end

  def deduct(amount)
    @balance -= amount
  end

end
