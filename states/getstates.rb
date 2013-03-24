File.open("states.list") do |file|
  file.readlines.each do |line|
    parts=line.split('"')
    state=parts[1].strip.gsub(/ /,"_")
    ref_link=parts[0]
    href="www.vegguide.org#{ref_link}.rss"
    puts state+" " + href
    system("wget #{href} -O #{state}.rss") 
  end
end
  

