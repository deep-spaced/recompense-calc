require 'date'

class Project
  def initialize(rate, start_date, end_date)
    @rate = rate
    @start_date = Date.parse(start_date)
    @end_date = Date.parse(end_date)
  end

  def cost
    total_days = (@start_date..@end_date).count
    travel_days = 2
    full_days = total_days - travel_days

    (full_days * @rate) + (travel_days * (@rate.to_f / 2))
  end
end