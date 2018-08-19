require 'pry-nav'
require 'pry-remote'
require 'pp'
require 'active_support/time'
require 'byebug'

@clicks = [
{ ip:'22.22.22.22', timestamp:'3/11/2016 02:02:58', amount: 7.00 },
{ ip:'11.11.11.11', timestamp:'3/11/2016 02:12:32', amount: 6.50 },
{ ip:'11.11.11.11', timestamp:'3/11/2016 02:13:11', amount: 7.25 },
{ ip:'11.11.11.11', timestamp:'3/11/2016 02:12:11', amount: 7.25 },
{ ip:'44.44.44.44', timestamp:'3/11/2016 02:13:54', amount: 8.74 },
{ ip:'44.44.44.44', timestamp:'3/11/2016 02:13:54', amount: 8.75 },
{ ip:'44.44.44.44', timestamp:'3/11/2016 02:13:54', amount: 8.76 },
{ ip:'22.22.22.22', timestamp:'3/11/2016 05:02:45', amount: 11.00 },
{ ip:'44.44.44.44', timestamp:'3/11/2016 06:32:42', amount: 5.00 },
{ ip:'22.22.22.22', timestamp:'3/11/2016 06:35:12', amount: 2.00 },
{ ip:'11.11.11.11', timestamp:'3/11/2016 06:45:01', amount: 12.00 },
{ ip:'11.11.11.11', timestamp:'3/11/2016 06:59:59', amount: 11.75 },
{ ip:'22.22.22.22', timestamp:'3/11/2016 07:01:53', amount: 1.00 },
{ ip:'11.11.11.11', timestamp:'3/11/2016 07:02:54', amount: 4.50 },
{ ip:'33.33.33.33', timestamp:'3/11/2016 07:02:54', amount: 15.75 },
{ ip:'66.66.66.66', timestamp:'3/11/2016 07:02:54', amount: 14.25 },
{ ip:'22.22.22.22', timestamp:'3/11/2016 07:03:15', amount: 12.00 },
{ ip:'22.22.22.22', timestamp:'3/11/2016 08:02:22', amount: 3.00 },
{ ip:'22.22.22.22', timestamp:'3/11/2016 09:41:50', amount: 4.00 },
{ ip:'22.22.22.22', timestamp:'3/11/2016 10:02:54', amount: 5.00 },
{ ip:'22.22.22.22', timestamp:'3/11/2016 11:05:35', amount: 10.00 },
{ ip:'22.22.22.22', timestamp:'3/11/2016 13:02:21', amount: 6.00 },
{ ip:'55.55.55.55', timestamp:'3/11/2016 13:02:40', amount: 8.00 }, #8?
{ ip:'44.44.44.44', timestamp:'3/11/2016 13:02:55', amount: 8.00 },
{ ip:'55.55.55.55', timestamp:'3/11/2016 13:33:34', amount: 8.00 },
{ ip:'55.55.55.55', timestamp:'3/11/2016 13:42:24', amount: 8.00 },
{ ip:'55.55.55.55', timestamp:'3/11/2016 13:47:44', amount: 6.25 },
{ ip:'55.55.55.55', timestamp:'3/11/2016 14:02:54', amount: 4.25 },
{ ip:'55.55.55.55', timestamp:'3/11/2016 14:03:04', amount: 5.25 },
{ ip:'55.55.55.55', timestamp:'3/11/2016 15:12:55', amount: 6.25 },
{ ip:'22.22.22.22', timestamp:'3/11/2016 16:02:36', amount: 8.00 },
{ ip:'55.55.55.55', timestamp:'3/11/2016 16:22:11', amount: 8.50 },
{ ip:'55.55.55.55', timestamp:'3/11/2016 17:18:19', amount: 11.25 },
{ ip:'55.55.55.55', timestamp:'3/11/2016 18:19:20', amount: 9.00 }, #index 19?
{ ip:'22.22.22.22', timestamp:'3/11/2016 23:59:59', amount: 9.00 }
]


def get_time_obj_keys(click)
    time_obj_keys = {}

    time_obj_keys["time_of_click"] = DateTime.parse(click[:timestamp])
    time_obj_keys["start_of_time_block"] = time_obj_keys["time_of_click"].beginning_of_hour
    time_obj_keys["end_of_time_block"] = time_obj_keys["time_of_click"].beginning_of_hour + 59.minutes

    time_obj_keys
end

def get_clicks_with_in_period(clicks)
    #an object is used to hold time blocks
    time_range_obj = {}

    clicks.each do |click|
        time_obj_keys = get_time_obj_keys(click)
       
        start_time_string = time_obj_keys["start_of_time_block"].strftime
        end_time_string = time_obj_keys["end_of_time_block"].strftime

        #if no time block exists for the current click create one
        time_range_obj[start_time_string] ||= Array.new
        time_range_obj[end_time_string] ||= Array.new

        #determine what time block the click should be in and push it in to the array
        time_obj_keys["time_of_click"] >= time_obj_keys["start_of_time_block"] ? time_range_obj[start_time_string].push(click) : time_range_obj[end_time_string].push(click)
    end
    time_range_obj
end

def sort_obj_by_time(click_obj)
    click_obj.sort{|click1, click2| click1[:timestamp] <=> click2[:timestamp]}
end

def filter_for_10_or_more_clicks(clicks)
    click_count = []

    # sorting is required to get the deletes to work
    sort_obj_by_time(clicks).each do |item|
        click_count.push(item[:ip])
        
        #the delete_if removes duplicates, it requires a logical operation
        current_ip = item[:ip]

        if click_count.select{|ip| ip == item[:ip]}.count >= 10
            delete_click_obj(clicks, current_ip)
        end
    end
    clicks
end


def delete_click_obj(clicks, current_ip)
    clicks.delete_if{ |click| click[:ip] == current_ip} 
end


def group_clicks_by_ip(click_obj)
    click_obj.group_by{|click_group_ip| click_group_ip[:ip]}
end

def get_max_value(click_obj)
    click_obj.map{|key, value| value.max_by{ |click_for_max| click_for_max[:amount]}}
end


def get_best_time_value_click(time_obj)
    result = []
    highest_values = time_obj.each do |key, click_obj|
        sorted_obj = sort_obj_by_time(click_obj)
        grouped_obj = group_clicks_by_ip(sorted_obj)
        max_value_found = get_max_value(grouped_obj)

        result.push(max_value_found)
    end
    result = result.flatten
end

def write_to_file(result)
    File.open('result-set.txt', 'w') { |file| file.write(result) }
end

def print_result(result)
    pp result
end

filtered_clicks = filter_for_10_or_more_clicks(@clicks)

time_obj =  get_clicks_with_in_period(filtered_clicks)

result = get_best_time_value_click(time_obj)

write_to_file(result)
print_result(result)