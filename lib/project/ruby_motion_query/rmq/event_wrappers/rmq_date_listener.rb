class RMQDateListener

  def initialize(&block)
    @block = block
  end

  def onDateSet(view, year, month_of_year, day_of_month)
    # TODO bug RM or BP ?
    #time = Time.new(year, month_of_year, day_of_month)
    #mp time.inspect
    time = Time.from_string("#{year}-#{month_of_year + 1}-#{day_of_month}")
    @block.call(time) if @block
  end
end