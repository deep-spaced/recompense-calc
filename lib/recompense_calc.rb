require 'project'

class RecompenseCalc

  def initialize
    @projects = []
  end

  def add_project(rate, start_date, end_date)
    @projects.push(Project.new(rate, start_date, end_date))
  end

  def total
    @projects.reduce(0) {|total, p| total += p.cost }
  end

  def to_s
    calculate.to_s
  end

end