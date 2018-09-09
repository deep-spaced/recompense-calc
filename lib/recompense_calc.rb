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
    @project_calendar = {}
  end

  def projects
    @projects
  end

  def add_project(rate, start_date, end_date)
    parsed_start = Date.parse(start_date)
    parsed_end = Date.parse(end_date)

    new_project = {
      id: SecureRandom.uuid,
      rate: rate,
      start_date: parsed_start,
      end_date: parsed_end,
    }

    @projects.push(new_project)
    add_to_calendar(new_project)
  end

  def total
    total = 0.0
    # binding.pry

    @project_calendar.each do |key, day|
      total += RATES[day[:rate]][day[:type]]
    end

    total.to_f
  end

  private

  def add_to_calendar(project)
    (project[:start_date]..project[:end_date]).each do |day|
      # Check calendar for existing day
      if @project_calendar[day].nil?
        # Add the day to the calendar:
        @project_calendar[day] = {
          rate: project[:rate],
          type: travel_or_full(day, project)
        }
      else
        # Update the rate and previous day:
        existing_rate = RATES[@project_calendar[day][:rate]][:full]
        new_rate = RATES[project[:rate]][:full]
        if new_rate > existing_rate
          @project_calendar[day][:rate] = project[:rate]
        end

        # Update the type to full.
        @project_calendar[day][:type] = :full
      end
    end
  end

  def travel_or_full(day, project)
    type = :travel
    type = :full if project[:start_date] != day and project[:end_date] != day
    type = :full if project[:start_date] == project[:end_date]

    # Check previous day:
    # binding.pry if day == Date.parse("2015-09-02")
    if day == project[:start_date] and
       !@project_calendar[day-1].nil? # and
      #  @project_calendar[day-1][:type] == :travel

      # Convert this and the previous day to a full day.
      @project_calendar[day-1][:type] = :full
      type = :full
    end

    # Check next day:
    if day == project[:end_date] and
       !@project_calendar[day+1].nil?

      # Convert this and the previous day to a full day.
      @project_calendar[day+1][:type] = :fula
      type = :full
    end

    type
  end
end