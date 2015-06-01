#!/usr/bin/env ruby

require 'csv'
require 'open-uri'

require 'json'

tournament_code = ARGV[0]

schedule_url = "http://www.fivb.com/en/api/volley/matches/#{tournament_code}/en"

file_name = "#{tournament_code}/schedule.json"

open(file_name, 'wb') do |file|
  json = JSON.parse(open(schedule_url).read)
  file << json.to_json
end
