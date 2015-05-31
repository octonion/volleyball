#!/usr/bin/env ruby

require 'csv'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'

path = '//*[@id="table2"]/tr[position()>2]'

year = ARGV[0]

phases = CSV.open("csv/phases_#{year}.csv", "r", {:headers => TRUE})

results = CSV.open("csv/results_#{year}.csv", "w")

header = ["year","phase_id","phase_name","match_id","teams","date","local_time","gmt_time","results","description_url","press_conference_url","dir_id","p3_url","p2_url"]

results << header

phases.each do |phase|

  #year = phase["year"]
  phase_id = phase["phase_id"]
  phase_name = phase["phase_name"]

  print "#{year}/#{phase_name}"

  url = "http://www.fivb.org/EN/volleyball/competitions/WorldLeague/#{year}/Matchinfo.asp?Phase=#{phase_id}&B3=Show"

  page = agent.get(url)

  found = 0
  page.parser.xpath(path).each do |tr|

    row = [year, phase_id, phase_name]

    tr.xpath("td").each_with_index do |td,j|

      case j
      when 6,7
        href = td.xpath("a").first.attributes["href"].to_s rescue nil
        full_url = URI.join(url, href)
        text = td.text.scrub.strip rescue nil
        row += [full_url]
      when 8
        href = td.xpath("font/a").first.attributes["href"].to_s rescue nil
        href_s = href.split("/")
        dir_id = href_s[5]
        full_url = URI.join(url, href)
        text = td.text.scrub.strip rescue nil
        row += [dir_id,full_url]
      when 9
        href = td.xpath("font/a").first.attributes["href"].to_s rescue nil
        full_url = URI.join(url, href)
        text = td.text.scrub.strip rescue nil
        row += [full_url]
      else
        text = td.text.scrub.strip rescue nil
        row += [text]
      end
      
    end

    results << row
    found += 1
  
  end
  print " - #{found}\n"

end

results.close

phases.close
