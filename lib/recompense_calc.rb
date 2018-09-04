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
    # Loop through each project:
    projects.map do |p1|
      # And compare it to every other project.
      projects.each do |p2|
        next if p2 == p1 # Ignore if the same project.

        # Convert travel days to full days:
        start_expanded = p1[:start_date] - 1
        end_expanded = p1[:end_date] + 1

        # Convert travel days:
        if p2[:end_date].between?(start_expanded, end_expanded) or
          p2[:start_date].between?(start_expanded, end_expanded)

          p1[:full_days] += 1
          p1[:travel_days] -= 1
        end

        # Calculate overlap:
        if p2[:start_date].between?(p1[:start_date], p1[:end_date]) # or
           # Add the one because there is at least one day of overlap.
          overlap = (p1[:end_date] - p2[:start_date]) + 1
          p1[:full_days] -= overlap

          # Add the days back if this has the higher rate:
          if p1[:rate] > p2[:rate]
            p1[:full_days] += overlap
          end
        end

      end
      p1
    end
  end

end