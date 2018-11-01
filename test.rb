require 'uri/http'
require 'net/http'
require 'json'

@base_url = "http://api.viki.io/v4/videos.json?app=100250a&per_page=10"

def get_response_by_json(page_number)
  url = "#{@base_url}&page=#{page_number}"
  res = Net::HTTP.get_response(URI(url))
  JSON.parse(res.body)
end

more_page = true
hd_flag_true_count = 0
hd_flag_false_count = 0
page = 900

until !more_page
  page_response = get_response_by_json(page)
  more_page = page_response['more']
  json_response = get_response_by_json(page)['response']

  json_response.each do |response|
    if response['flags']['hd']
      hd_flag_true_count = hd_flag_true_count + 1
    else
      hd_flag_false_count = hd_flag_false_count + 1
    end

  end
  puts "Checking page #{page}. True Flags = #{hd_flag_true_count}. False Flags = #{hd_flag_false_count}"
  page = page + 1
end

puts "Total Amount of True HD Flags: #{hd_flag_true_count}"
puts "Total Amount of False HD Flags: #{hd_flag_false_count}"
