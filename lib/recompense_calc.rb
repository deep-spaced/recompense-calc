require 'date'
require 'securerandom'
require 'pry'

class RecompenseCalc

  RATES = {
    low: { travel: 45, full: 75 },
    high: { travel: 55, full: 85 }
  }

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
    # pp processed_projects.inspect
    calculate_costs(processed_projects)
  end

  private

  def generate_project(rate, start_date, end_date)
    parsed_start = Date.parse(start_date)
    parsed_end = Date.parse(end_date)

    total_days = (parsed_start..parsed_end).count
    travel_days = total_days >= 2 ? 2 : 0

    {
      id: SecureRandom.uuid,
      rate: rate,
      start_date: parsed_start,
      end_date: parsed_end,
      travel_days: travel_days,
      full_days: total_days - travel_days
    }
  end

  def calculate_costs(projects)
    # Gather the cost info into an ordered data structure:
    # cost_info = {low: {full: 0, travel: 0}}
    cost_info = {}
    projects.each do |p|
      rate = p[:rate]
      cost_info[rate] = cost_info[rate] || {travel: 0, full: 0}

      cost_info[rate][:travel] += p[:travel_days]
      cost_info[rate][:full] += p[:full_days]
    end

    total = 0
    cost_info.each_pair do |rate, days|
      total += (days[:full] * RATES[rate][:full])
      total += (days[:travel] * RATES[rate][:travel])
    end

    total.to_f
  end

  # Rules

  def apply_rules(projects)
    # Loop through each project:
    projects.map do |p1|
      # And compare it to every other project.
      projects.each do |p2|
        next if p2 == p1 # Ignore if the same project.

        # Convert travel days to full days:
        start_expanded = p1[:start_date] - 1
        end_expanded = p1[:end_date] + 1

        # If the projects push up against each other:
        if p2[:end_date].between?(start_expanded, end_expanded) or
          p2[:start_date].between?(start_expanded, end_expanded)

          p1[:full_days] += 1
          p1[:travel_days] -= (p1[:travel_days] == 0 ? 0 : 1)
        end

        # Calculate any project overlap:
        if p2[:start_date].between?(p1[:start_date], p1[:end_date]) # or
           # Add the one because there is at least one day of overlap.
          overlap = (p1[:end_date] - p2[:start_date]) + 1
          # binding.pry
          p1[:full_days] -= overlap
          # binding.pry

          # Add the days back if this has the higher rate:
          if RATES[p1[:rate]][:full] > RATES[p2[:rate]][:full]
            p1[:full_days] += overlap
          end
        end

        # If the two projects have the same project time and same rate,
        # then they should each have the math for half the time:
        # if (p1[:start_date]..p1[:end_date]) == (p2[:start_date]..p2[:end_date]) and p1[:rate] == p2[:rate]
        #   p1[:full_days] = (p1[:full_days] / 2).to_f
        # end

      end
      p1
    end
  end

end