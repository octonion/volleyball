#!/usr/bin/env ruby

require 'csv'
require 'open-uri'

require 'json'

tournament_code = ARGV[0]

year = ARGV[1]

base = "http://www.fivb.com/en/api/volley/matches"
#/WL2015-1/en/live/5869
#http://worldleague.2015.fivb.com/en/api/volley/matches/WL2015-1/en/stats/5869

schedule = JSON.parse(File.read("#{tournament_code}/schedule.json"))

found = 0
schedule["Matches"].each do |match|

  id = match["Id"].to_i
  match_id = match["MatchNumber"].to_i
  tournament_id = match["TournamentCode"]
  match_date = match["LocalDateTime"].split("T")[0]
  match_date = Date.strptime(match_date, '%Y-%m-%d')

  if (match_date <= Date.today)
    url = "#{base}/#{tournament_id}/en/stats/#{id}"

    file_name = "#{tournament_code}/stats_#{id}.json"

    open(file_name, 'wb') do |file|
      file << JSON.parse(open(url).read).to_json
    end
    found += 1
  end
  
end

print "Found #{found}\n"
