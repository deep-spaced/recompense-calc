require 'date'

class RecompenseCalc

  def initialize
    @projects = []
  end

  def projects
    @projects
  end

  def add_project(rate, start_date, end_date)
    @projects.push generate_project(rate, start_date, end_date)
  end

  def total
    calculate_costs(@projects)
  end

  private

  def generate_project(rate, start_date, end_date)
    parsed_start = Date.parse(start_date)
    parsed_end = Date.parse(end_date)

    total_days = (parsed_start..parsed_end).count
    travel_days = total_days >= 2 ? 2 : 0

    {
      rate: rate.to_i,
      start_date: parsed_start,
      end_date: parsed_end,
      travel_days: travel_days,
      full_days: total_days - travel_days
    }
  end

  def calculate_costs(projects)
    cost_info = {}
    projects.each do |p|
      cost_info[p[:rate]] = cost_info[p[:rate]] || {travel: 0, full: 0}

      cost_info[p[:rate]][:travel] += p[:travel_days]
      cost_info[p[:rate]][:full] += p[:full_days]
    end

    total = 0
    cost_info.each_pair do |rate, days|
      total += (days[:full] * rate) + (days[:travel] * (rate.to_f/2))
    end

    total
  end
end