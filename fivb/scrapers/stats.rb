#!/usr/bin/env ruby

require 'csv'
require 'open-uri'

year = ARGV[0]

base = "http://www.fivb.org/visweb6/xml_vlivescore.aspx?TournCode="

results = CSV.open("csv/results_#{year}.csv", "r", {:headers => TRUE})

print "#{year}"

found = 0
results.each do |result|

  year_id = result["year"]
  phase_id = result["phase_id"]
  phase_name = result["phase_name"]
  match_id = result["match_id"]
  dir_id = result["dir_id"]

  url = "#{base}#{dir_id}&Type=Stats&NoMatch=#{match_id}"

  file_name = "xml/stats_#{year_id}_#{phase_id}_#{match_id}.xml"

  open(file_name, 'wb') do |file|
    file << open(url).read
  end
  found += 1

end

print " - #{found}\n"

results.close
