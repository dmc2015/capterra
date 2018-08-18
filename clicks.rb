require 'pry-nav'
require 'pry-remote'
require 'pp'

@clicks = [
{ ip:'22.22.22.22', timestamp:'3/11/2016 02:02:58', amount: 7.00 },
{ ip:'11.11.11.11', timestamp:'3/11/2016 02:12:32', amount: 6.50 },
{ ip:'11.11.11.11', timestamp:'3/11/2016 02:13:11', amount: 7.25 },
{ ip:'44.44.44.44', timestamp:'3/11/2016 02:13:54', amount: 8.75 },
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




def get_most_expensive_click
end

def get_clicks_with_in_period
end

def filter_duplicates_from_period
end

def get_earliest_click
end

def filter_for_bot_clicks(clicks)
    #if there are more than 10 clicks from one ip remove those clicks
    #filters out click events that have 10 or more click
    click_count = []
    # I added a sort here because I noticed that this was filter for delete was not deleting all the instances of 55.55.55.55, it seemed to be getting the indices wrong
    # sorting resolved this
    clicks.sort{ |click_event1, click_event2| click_event1["ip"] <=> click_event2["ip"] }.each_with_index do |item, index|
    click_count.push(item[:ip])
    current_ip = item[:ip]
        if click_count.select{|ip| ip == item[:ip]}.count >= 10
            clicks.delete_if{ |x| x[:ip] == current_ip} 
        end
    end
    clicks
end


pp filter_for_bot_clicks(@clicks)