require "test/unit"
require 'pry-nav'
require 'pry-remote'
require 'pp'
require 'active_support/time'
require 'byebug'

require_relative "solution"

class TestSolution < Test::Unit::TestCase
    
    def setup
        @clicks = [
            { ip:'22.22.22.22', timestamp:'3/11/2016 02:02:58', amount: 7.00 },
            { ip:'55.55.55.55', timestamp:'3/11/2016 16:22:11', amount: 8.50 },
            { ip:'55.55.55.55', timestamp:'3/11/2016 17:18:19', amount: 11.25 },
            { ip:'55.55.55.55', timestamp:'3/11/2016 18:19:20', amount: 9.00 }, 
            { ip:'22.22.22.22', timestamp:'3/11/2016 23:59:59', amount: 9.00 },
            { ip:'55.55.55.55', timestamp:'3/11/2016 14:02:54', amount: 4.25 }
        ]

        @CF = ClickFinder
    end

    def test_data        
        middle_value = @clicks.count / 2

        assert_equal(@clicks.last, { ip:'55.55.55.55', timestamp:'3/11/2016 14:02:54', amount: 4.25 }, "the expected data value for the last item is incorrect")
        assert_equal(@clicks.first, { ip:'22.22.22.22', timestamp:'3/11/2016 02:02:58', amount: 7.00 }, "the expected data value for the first item is incorrect")
        assert_equal(@clicks[middle_value], { ip:'55.55.55.55', timestamp:'3/11/2016 18:19:20', amount: 9.00}, "the expected data value for the first item is incorrect")
    end

    def test_get_time_obj_keys
        first_click = @clicks.first

        assert_instance_of(DateTime, @CF.get_time_obj_keys(first_click)["time_of_click"], "get_time_obj_keys failed to return the key time_of_click")
        assert_instance_of(DateTime, @CF.get_time_obj_keys(first_click)["end_of_time_block"], "get_time_obj_keys failed to return the key end_of_time_block")
        assert_instance_of(DateTime, @CF.get_time_obj_keys(first_click)["start_of_time_block"],  "get_time_obj_keys failed to return the key start_of_time_block")
    end

    def test_get_clicks_with_in_period
        assert_equal(12, @CF.get_clicks_with_in_period(@clicks).count, "Objects Created While Making Time Periods Is Off")
    end

    def test_sort_obj_by_time
        assert_equal("22.22.22.22", @CF.get_clicks_with_in_period(@clicks)["2016-11-03T02:00:00+00:00"][0][:ip], "sort_obj_by_time failed to sort")
    end

    def test_filter_for_10_or_more_clicks
        tests_of_10_should_equal =  [
            {:ip=>"55.55.55.55", :timestamp=>"3/11/2016 16:22:11", :amount=>8.5},
            {:ip=>"55.55.55.55", :timestamp=>"3/11/2016 17:18:19", :amount=>11.25},
            {:ip=>"55.55.55.55", :timestamp=>"3/11/2016 18:19:20", :amount=>9.0},
            {:ip=>"55.55.55.55", :timestamp=>"3/11/2016 14:02:54", :amount=>4.25}
        ]

        clicks_10 = [
            { ip:'22.22.22.22', timestamp:'3/11/2016 02:02:58', amount: 7.00 },
            { ip:'22.22.22.22', timestamp:'3/11/2016 02:02:58', amount: 7.00 },
            { ip:'22.22.22.22', timestamp:'3/11/2016 02:02:58', amount: 7.00 },
            { ip:'22.22.22.22', timestamp:'3/11/2016 02:02:58', amount: 7.00 },
            { ip:'22.22.22.22', timestamp:'3/11/2016 02:02:58', amount: 7.00 },
            { ip:'22.22.22.22', timestamp:'3/11/2016 02:02:58', amount: 7.00 },
            { ip:'22.22.22.22', timestamp:'3/11/2016 02:02:58', amount: 7.00 },
            { ip:'22.22.22.22', timestamp:'3/11/2016 02:02:58', amount: 7.00 },
            { ip:'22.22.22.22', timestamp:'3/11/2016 02:02:58', amount: 7.00 },
            { ip:'55.55.55.55', timestamp:'3/11/2016 16:22:11', amount: 8.50 },
            { ip:'55.55.55.55', timestamp:'3/11/2016 17:18:19', amount: 11.25 },
            { ip:'55.55.55.55', timestamp:'3/11/2016 18:19:20', amount: 9.00 }, 
            { ip:'22.22.22.22', timestamp:'3/11/2016 23:59:59', amount: 9.00 },
            { ip:'55.55.55.55', timestamp:'3/11/2016 14:02:54', amount: 4.25 }
        ]

        assert_equal(tests_of_10_should_equal, @CF.filter_for_10_or_more_clicks(clicks_10), "filter_for_10_or_more_clicks failed, it is supposed to delete any objects that have the 10 or more instances of an ip address")
    end

    def test_delete_click_obj
        result = [{:ip=>"22.22.22.22", :timestamp=>"3/11/2016 02:02:58", :amount=>7.0}, {:ip=>"22.22.22.22", :timestamp=>"3/11/2016 23:59:59", :amount=>9.0}]
        assert_equal(result, @CF.delete_click_obj(@clicks, "55.55.55.55"), "delete_click_obj has failed, it should delete objects, the first object, that are passed to it, the second argument")
    end

    def test_group_clicks_by_ip
        grouped_by_ips = 
        {
            "22.22.22.22"=>
                [{:ip=>"22.22.22.22", :timestamp=>"3/11/2016 02:02:58", :amount=>7.0},
                {:ip=>"22.22.22.22", :timestamp=>"3/11/2016 23:59:59", :amount=>9.0}],
            "55.55.55.55"=>
                [{:ip=>"55.55.55.55", :timestamp=>"3/11/2016 16:22:11", :amount=>8.5},
                {:ip=>"55.55.55.55", :timestamp=>"3/11/2016 17:18:19", :amount=>11.25},
                {:ip=>"55.55.55.55", :timestamp=>"3/11/2016 18:19:20", :amount=>9.0},
                {:ip=>"55.55.55.55", :timestamp=>"3/11/2016 14:02:54", :amount=>4.25}]
        }

        assert_equal(grouped_by_ips, @CF.group_clicks_by_ip(@clicks), "group_clicks_by_ip has failed, it should take a data set of clicks and group them by ip address")
    end

    def test_get_max_value
        max_value_objects = [{:ip=>"22.22.22.22", :timestamp=>"3/11/2016 23:59:59", :amount=>9.0}, {:ip=>"55.55.55.55", :timestamp=>"3/11/2016 17:18:19", :amount=>11.25}]
        assert_equal(max_value_objects, @CF.get_max_value(@CF.group_clicks_by_ip(@clicks)), "get_max_value method is failed, it should iterate through clicks and return the max values" )
    end

    def test_get_valid_clicks
        result = [{:ip=>"22.22.22.22", :timestamp=>"3/11/2016 02:02:58", :amount=>7.0},
                    {:ip=>"55.55.55.55", :timestamp=>"3/11/2016 16:22:11", :amount=>8.5},
                    {:ip=>"55.55.55.55", :timestamp=>"3/11/2016 17:18:19", :amount=>11.25},
                    {:ip=>"55.55.55.55", :timestamp=>"3/11/2016 18:19:20", :amount=>9.0},
                    {:ip=>"22.22.22.22", :timestamp=>"3/11/2016 23:59:59", :amount=>9.0},
                    {:ip=>"55.55.55.55", :timestamp=>"3/11/2016 14:02:54", :amount=>4.25}
                ]
       assert_equal(result, @CF.get_valid_clicks(@clicks), "get_valid_clicks has failed, this is the main method")
    end

end