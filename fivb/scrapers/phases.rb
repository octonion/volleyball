#!/usr/bin/env ruby

require 'csv'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'

path = '//select/option[position()>1]'

#path = '/html/body/div/div[2]/div/form/table/tr/td[1]/select/option[position()>1]'

year = ARGV[0].to_i

url = "http://www.fivb.org/EN/volleyball/competitions/WorldLeague/#{year}/Matchinfo.asp"

#results << ["league_id", "season_id", "league_season_url", "league_season_name"]

results = CSV.open("csv/phases_#{year}.csv", "w")

header = ["year","phase_id","phase_name"]

results << header

page = agent.get(url)

found = 0
page.parser.xpath(path).each do |option|

  phase_id = option.attributes["value"].to_s.to_i
  phase_name = option.text
  row = [year, phase_id, option.text]

  print "  #{year}/#{phase_name}\n"
  found += 1
  results << row
  
end

results.close

print "Found #{found} phases\n"
