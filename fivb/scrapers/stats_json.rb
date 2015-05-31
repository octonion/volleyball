#!/usr/bin/env ruby

require 'csv'
require 'open-uri'

require 'json'

year = ARGV[0]

base = "http://www.fivb.org/visweb6/xml_vlivescore.aspx?TournCode="

schedule = JSON.parse(File.read("json/schedule_#{year}.json"))

print "#{year}"

found = 0
schedule["Matches"].each do |match|

  id = match["Id"].to_i
  match_id = match["MatchNumber"].to_i
  tournament_id = match["TournamentCode"]
  match_date = match["LocalDateTime"].split("T")[0]
  match_date = Date.strptime(match_date, '%Y-%m-%d')

  if (match_date <= Date.today)
    url = "#{base}#{tournament_id}&Type=Stats&NoMatch=#{match_id}"

    file_name = "xml/stats_#{year}_#{id}_#{match_id}.xml"

    open(file_name, 'wb') do |file|
      file << open(url).read
    end
    found += 1
  end
  
end

print " - #{found}\n"
