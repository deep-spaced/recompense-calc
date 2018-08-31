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
    processed_projects = apply_rules(@projects)
    calculate_costs(processed_projects)
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
    # Gather the cost info into an ordered data structure:
    # cost_info = {45 => {full: 0, travel: 0}}
    cost_info = {}
    projects.each do |p|
      rate = p[:rate]
      cost_info[rate] = cost_info[rate] || {travel: 0, full: 0}

      cost_info[rate][:travel] += p[:travel_days]
      cost_info[rate][:full] += p[:full_days]
    end

    total = 0
    cost_info.each_pair do |rate, days|
      total += (days[:full] * rate) + (days[:travel] * (rate.to_f/2))
    end

    total
  end

  # Rules

  def apply_rules(projects)
    projects = rule_end_to_end(projects)
  end

  def rule_end_to_end(projects)
    projects
    # If the start of one project is the same as the end of another project....
    # Compare the rates:
    # - add one full day day to higher rated project
    # - remove one travel day from each project
    # Return modified project array
  end
end