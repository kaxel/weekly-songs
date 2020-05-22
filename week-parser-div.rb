require 'csv'

def get_small(li)
  chopped = li.split("/")
  #youtube or spotify
  if li.include?("open.spotify.com")
    return "<iframe src=\"https://open.spotify.com/embed/track/#{chopped.reverse()[0]}\" width=\"300\" height=\"380\" frameborder=\"0\" allowtransparency=\"true\" allow=\"encrypted-media\"></iframe>"
  elsif li.include?("soundcloud.com")
    #disabled due to private links
    return "<iframe width=\"300\" height=\"380\" scrolling=\"no\" frameborder=\"no\" src=\"#{li}\"></iframe>"
  elsif li.include?("youtube.com")
    x = li.split("?")
    y = x[1].split("&")
    z = y[0].gsub!("v=", "")
    return "<iframe width=\"500\" height=\"300\" src=\"https://www.youtube.com/embed/#{z}?controls=0\" frameborder=\"0\" allow=\"accelerometer; encrypted-media; gyroscope; picture-in-picture\"></iframe>"
  elsif li.include?("youtu.be")
    return "<iframe width=\"500\" height=\"300\" src=\"https://www.youtube.com/embed/#{chopped.reverse()[0]}?controls=0\" frameborder=\"0\" allow=\"accelerometer; encrypted-media; gyroscope; picture-in-picture\"></iframe>"
  end
end

def get_applause(li)
  return "<applause-button style=\"width: 58px; height: 58px;\" url=\"#{li}\" />"
end

t_stamp = Time.now.to_i
slug = "#{t_stamp}.txt"
slug_ig = "#{t_stamp}_ig.txt"
slug_tw = "#{t_stamp}_tw.txt"
ig_tbl = "Songs-Socials-IG.csv"
tw_tbl = "Songs-Socials-Twitter.csv"
spot_tbl = "Songs-spotify links.csv"

#string="<table>"
string=""
string_ig=""
string_tw=""
table = CSV.parse(File.read(spot_tbl), headers: true)

table.each do |t|
  name ="#{t[0]} by #{t[1]}"
  link = t[2]
  small_link = get_small(link)
  if link.include?("youtube.com") || link.include?("youtu.be")
    string<<"
    <h3>#{name}</h3>
    <table style=\"width: 420px;\"><tr><td style=\"width: 350px;\">#{get_small(link)}</td><td>#{get_applause(link)}</td></tr></table>"
  else
    string<<"
    <h3>#{name}</h3>
    <table style=\"width: 420px;\"><tr><td style=\"width: 350px;\">#{get_small(link)}</td><td>#{get_applause(link)}</td></tr></table>"
    
    #<div style='width: 450px;'>#{get_small(link)}<div style='float:right;'>#{get_applause(link)}</div></div><br/>
  end
end

File.open(slug,"w") do |f|
  f.write(string)
end

ig =  CSV.parse(File.read(ig_tbl), headers: true)
ig.each do |t|
  tag = t[1]
  if tag.include?("instagram.com/")
    insert = tag.split("instagram.com/")[1]
    if insert.include?("/")
      insert = insert.split("/")[0]
    elsif insert.include?("?")
      insert = insert.split("?")[0]
    end
  else
    insert = tag
  end
  string_ig<<"@#{insert} "
end

File.open(slug_ig,"w") do |f|
  f.write(string_ig)
end

tw = CSV.parse(File.read(tw_tbl), headers: true)
tw.each do |t|
  tag = t[1]
  insert = tag.split("twitter.com/")
  string_tw<<"@#{insert[1]} "
end

File.open(slug_tw,"w") do |f|
  f.write(string_tw)
end