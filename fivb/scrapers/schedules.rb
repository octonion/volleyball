#!/usr/bin/env ruby

require 'csv'
require 'open-uri'

require 'json'

year = ARGV[0].to_i
groups = ARGV[1].to_i

group_url = "http://www.fivb.com/en/api/volley/matches/WL#{year}-"

full_url = "http://www.fivb.com/en/api/volley/matches/0/en"

file_name = "json/schedule_#{year}.json"

open(file_name, 'wb') do |file|
  json = JSON.parse(open(full_url).read)
  file << json.to_json
end

(1..groups).each do |group_id|

  url = "#{group_url}#{group_id}/en"

  file_name = "json/schedule_#{year}_#{group_id}.json"

  open(file_name, 'wb') do |file|
    json = JSON.parse(open(url).read)
    file << json.to_json
  end

end
