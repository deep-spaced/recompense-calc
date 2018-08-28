require "./lib/recompense_calc.rb"
require "test/unit"

class TestRecompenseCalc < Test::Unit::TestCase

  def test_single_project
    calc = RecompenseCalc.new
    calc.add_project(75, "2015-09-01", "2015-09-03")

    assert_equal(150, calc.total)
  end

end
