require "./lib/recompense_calc.rb"
require "test/unit"

class TestRecompenseCalc < Test::Unit::TestCase

  def test_add_project
    calc = RecompenseCalc.new
    calc.add_project(:high, "2015-09-01", "2015-09-03")
    calc.add_project(:high, "2015-09-01", "2015-09-03")

    assert_equal(calc.projects.size, 2)
  end

  def test_single_project
    calc = RecompenseCalc.new
    calc.add_project(:high, "2015-09-01", "2015-09-03")

    assert_equal(195, calc.total)
  end

  def test_single_day_project
    calc = RecompenseCalc.new
    calc.add_project(:high, "2015-09-01", "2015-09-01")

    assert_equal(85, calc.total)
  end

  def test_two_projects
    calc = RecompenseCalc.new
    calc.add_project(:low, "2015-09-01", "2015-09-03")
    calc.add_project(:high, "2015-09-05", "2015-09-07")
    # Travel at 45: 2
    # Full days at 75: 1
    # Travel days at 55: 2
    # Full days at 85: 1
    # Total: 360

    assert_equal(360, calc.total)
  end

  def test_two_projects_same_day
    calc = RecompenseCalc.new
    calc.add_project(:low, "2015-09-01", "2015-09-01")
    calc.add_project(:low, "2015-09-01", "2015-09-01")

    assert_equal(75, calc.total)
  end

  def test_two_projects_end_to_end
    calc = RecompenseCalc.new
    calc.add_project(:low, "2015-09-01", "2015-09-03")
    calc.add_project(:high, "2015-09-04", "2015-09-07")
    # Travel at 45: 1
    # Full days at 75: 2
    # Travel days at 55: 1
    # Full days at 85: 3
    # Total: 505

    assert_equal(505, calc.total)
  end

  def test_two_projects_overlap
    calc = RecompenseCalc.new
    calc.add_project(:low, "2015-09-01", "2015-09-04")
    calc.add_project(:low, "2015-09-03", "2015-09-08")
    # Travel at 45: 2
    # Full days at 75: 6
    # Total: 540

    assert_equal(540, calc.total)
  end

  def test_three_projects
    calc = RecompenseCalc.new
    calc.add_project(:low, "2015-09-01", "2015-09-03")
    calc.add_project(:high, "2015-09-05", "2015-09-07")
    calc.add_project(:low, "2015-09-09", "2015-09-11")
    # Travel at 45: 4
    # Full days at 75: 2
    # Travel days at 55: 2
    # Full days at 85: 1
    # Total: 525

    assert_equal(525, calc.total)
  end

  def test_three_projects_end_to_end
    calc = RecompenseCalc.new
    calc.add_project(:low, "2015-09-01", "2015-09-03")
    calc.add_project(:high, "2015-09-04", "2015-09-06")
    calc.add_project(:low, "2015-09-07", "2015-09-09")
    # Travel at 45: 2
    # Full days at 75: 4
    # Travel days at 55: 0
    # Full days at 85: 3
    # Total: 645

    assert_equal(645, calc.total)
  end

  def test_three_projects_overlap
    calc = RecompenseCalc.new
    calc.add_project(:low, "2015-09-01", "2015-09-05")
    calc.add_project(:high, "2015-09-04", "2015-09-08")
    calc.add_project(:low, "2015-09-09", "2015-09-12")
    # Travel at 45: 2
    # Full days at 75:  5
    # Travel days at 55: 0
    # Full days at 85: 5
    # Total: 890

    assert_equal(890, calc.total)
  end

  # Requested scenarios

  def test_set_one
    calc = RecompenseCalc.new
    calc.add_project(:high, "2015-09-01", "2015-09-03")

    assert_equal(195, calc.total)
  end

  def test_set_two
    calc = RecompenseCalc.new
    calc.add_project(:low, "2015-09-01", "2015-09-01")
    calc.add_project(:high, "2015-09-02", "2015-09-06")
    calc.add_project(:low, "2015-09-06", "2015-09-08")
    # Travel at 45: 1
    # Full days at 75: 2
    # Travel days at 55: 0
    # Full days at 85: 5
    # Total: 620

    assert_equal(620, calc.total)
  end

  def test_set_three
    calc = RecompenseCalc.new
    calc.add_project(:low, "2015-09-01", "2015-09-03")
    calc.add_project(:high, "2015-09-05", "2015-09-07")
    calc.add_project(:high, "2015-09-08", "2015-09-08")
    # Travel at 45: 2
    # Full days at 75: 1
    # Travel days at 55: 1
    # Full days at 85: 3
    # Total: 475

    assert_equal(475, calc.total)
  end

  def test_set_four
    calc = RecompenseCalc.new
    calc.add_project(:low, "2015-09-01", "2015-09-01")
    calc.add_project(:low, "2015-09-01", "2015-09-01")
    calc.add_project(:high, "2015-09-02", "2015-09-02")
    calc.add_project(:high, "2015-09-02", "2015-09-03")
    # Two ways to parse this:

    # Option 1: 9-3 is a travel day.
    # Math:
    # Travel at 45:
    # Full days at 75: 1
    # Travel days at 55: 1
    # Full days at 85: 1
    # Total: 215

    # Option 2: 9-3 is a full day because it is right beside
    # the end of another project.
    # Math:
    # Travel at 45:
    # Full days at 75: 1
    # Travel days at 55: 0
    # Full days at 85: 2
    # Total: 245

    assert_equal(215, calc.total)
  end

end
