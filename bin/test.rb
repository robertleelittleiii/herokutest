require 'rubygems'
require 'nokogiri'
require 'open-uri'

url = "http://www.monmouthoceanmls.com/(tdp3yamo1d0hu1rkv2jelhqn)/propertyResults.aspx?DTP=_parent&ShowNav=&CurrentRecord=&tex_mls_acct=&category=1&agent=195"
doc = Nokogiri::HTML(open(url))
puts doc.at_css("title").text
doc.css(".resultItemContainer").each do |item|
  a = Property.new
  a.title = item.at_css(".resultsPrice b").text rescue "nothing"
  a.price = item.at_css(".resultsPrice:nth-child(3) font").text[/\$[0-9\.]+/] rescue "nothing"
  a.municipality = item.at_css(".resultsDetailsTable tr:nth-child(2) td:nth-child(2)").text rescue "nothing"
  a.photo = item.at_css(".resultsPhoto") rescue "nothing"
  a.photo_url = a.photo[:src] rescue "nothing"
  a.save
  puts "#{a.title} - #{a.price}- #{a.municipality} #{a.photo[:alt]} #{a.photo[:src]}" rescue "nothing"
  #puts item.at_css(".prodLink")[:href]
end
