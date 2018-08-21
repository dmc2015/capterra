require "test/unit"
require 'pry-nav'
require 'pry-remote'
require 'pp'
require 'active_support/time'
require 'byebug'

require_relative "data"
require_relative "solution"

byebug
class TestSolution < Test::Unit::TestCase
    # CF = ClickFinder
    byebug
    def test_data
        byebug
        middle_value = ClickFinder::CLICKS.count / 2
        byebug

        assert_equal(ClickFinder::CLICKS.last, {:ip=>"22.22.22.22", :timestamp=>"3/11/2016 23:59:59", :amount=>9.0})
        assert_equal(ClickFinder::CLICKS.first, { ip:'22.22.22.22', timestamp:'3/11/2016 02:02:58', amount: 7.00 })
        assert_equal(ClickFinder::CLICKS[middle_value], {:ip=>"22.22.22.22", :timestamp=>"3/11/2016 08:02:22", :amount=>3.0})
    end

    def test_get_time_obj_keys
        first_click = ClickFinder::CLICKS.first

        # assert_equal(ClickFinder.get_time_obj_keys(first_click),
        #             {"time_of_click"=>Thu, 03 Nov 2016 02:02:58 +0000, "start_of_time_block"=>Thu, 03 Nov 2016 02:00:00 +0000, "end_of_time_block"=>Thu, 03 Nov 2016 02:59:00 +0000}
        #             )

        assert_respond_to(ClickFinder.get_time_obj_keys(first_click), "time_of_click")


    end

    def test_get_clicks_with_in_period
    end
    def test_sort_obj_by_time
    end
    def test_filter_for_10_or_more_clicks
    end
    def test_delete_click_obj
    end
    def test_group_clicks_by_ip
    end
    def test_get_max_value
    end
    def test_get_best_time_value_click
    end
    def test_write_to_file
    end
    def test_print_result
    end
    def test_get_valid_clicks
    end
end