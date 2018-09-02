require "./lib/recompense_calc.rb"
require "test/unit"

class TestRecompenseCalc < Test::Unit::TestCase

  def test_add_project
    calc = RecompenseCalc.new
    calc.add_project(75, "2015-09-01", "2015-09-03")
    calc.add_project(75, "2015-09-01", "2015-09-03")

    assert_equal(calc.projects.size, 2)
  end

  def test_single_project
    calc = RecompenseCalc.new
    calc.add_project(75, "2015-09-01", "2015-09-03")

    assert_equal(150, calc.total)
  end

  def test_two_projects
    calc = RecompenseCalc.new
    calc.add_project(45, "2015-09-01", "2015-09-03")
    calc.add_project(75, "2015-09-05", "2015-09-07")
    # Travel at 45: 2
    # Full days at 45: 1
    # Travel days at 75: 2
    # Full days at 75: 1
    # Total: 240

    assert_equal(240, calc.total)
  end

  def test_two_projects_end_to_end
    calc = RecompenseCalc.new
    calc.add_project(45, "2015-09-01", "2015-09-03")
    calc.add_project(75, "2015-09-04", "2015-09-07")
    # Travel at 45: 1
    # Full days at 45: 2
    # Travel days at 75: 1
    # Full days at 75: 3
    # Total: 375

    assert_equal(375, calc.total)
  end

  def test_three_projects
    calc = RecompenseCalc.new
    calc.add_project(45, "2015-09-01", "2015-09-01")
    calc.add_project(75, "3015-09-02", "2015-09-07")
    calc.add_project(45, "2015-09-09", "2015-09-11")
    # Travel at 45: 2
    # Full days at 45: 2
    # Travel days at 75: 2
    # Full days at 75: 4
    # Total:

    # assert_equal(510, calc.total)
  end

  def test_three_projects_overlap
    calc = RecompenseCalc.new
    calc.add_project(45, "2015-09-01", "2015-09-01")
    calc.add_project(75, "2015-09-02", "2015-09-06")
    calc.add_project(45, "2015-09-06", "2015-09-08")
    # Travel at 45: 1
    # Full days at 45: 2
    # Full days at 75: 5
    # Total: 375+112.5 = 487.5

    # assert_equal(487.5, calc.total)
  end
end
