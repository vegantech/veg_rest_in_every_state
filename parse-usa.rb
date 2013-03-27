STATE_ABBR = {
  'AL' => 'Alabama',
  'AK' => 'Alaska',
#  'AS' => 'America Samoa',
  'AZ' => 'Arizona',
  'AR' => 'Arkansas',
  'CA' => 'California',
  'CO' => 'Colorado',
  'CT' => 'Connecticut',
  'DE' => 'Delaware',
  'DC' => 'District of Columbia',
#  'FM' => 'Micronesia1',
  'FL' => 'Florida',
  'GA' => 'Georgia',
#  'GU' => 'Guam',
  'HI' => 'Hawaii',
  'ID' => 'Idaho',
  'IL' => 'Illinois',
  'IN' => 'Indiana',
  'IA' => 'Iowa',
  'KS' => 'Kansas',
  'KY' => 'Kentucky',
  'LA' => 'Louisiana',
  'ME' => 'Maine',
#  'MH' => 'Islands1',
  'MD' => 'Maryland',
  'MA' => 'Massachusetts',
  'MI' => 'Michigan',
  'MN' => 'Minnesota',
  'MS' => 'Mississippi',
  'MO' => 'Missouri',
  'MT' => 'Montana',
  'NE' => 'Nebraska',
  'NV' => 'Nevada',
  'NH' => 'New Hampshire',
  'NJ' => 'New Jersey',
  'NM' => 'New Mexico',
  'NY' => 'New York',
  'NC' => 'North Carolina',
  'ND' => 'North Dakota',
  'OH' => 'Ohio',
  'OK' => 'Oklahoma',
  'OR' => 'Oregon',
#  'PW' => 'Palau',
  'PA' => 'Pennsylvania',
#  'PR' => 'Puerto Rico',
  'RI' => 'Rhode Island',
  'SC' => 'South Carolina',
  'SD' => 'South Dakota',
  'TN' => 'Tennessee',
  'TX' => 'Texas',
  'UT' => 'Utah',
  'VT' => 'Vermont',
#  'VI' => 'Virgin Island',
  'VA' => 'Virginia',
  'WA' => 'Washington',
  'WV' => 'West Virginia',
  'WI' => 'Wisconsin',
  'WY' => 'Wyoming'
}

STATE_ABBR.values.each{ |v| STATE_ABBR[v.upcase]=v}

STATE_EXCEPTIONS = {
  8042 => "New Jersey",
  16433 => 'Florida',
  6024 => 'New Jersey',
  10048 => 'Massachusetts',
  11198 => 'Florida'
}


require 'nokogiri'
#require 'open-uri'
#doc = Nokogiri::XML(open("http://www.vegguide.org/region/2.rss"))

f=File.open 'usa.rss'
doc = Nokogiri::XML(f)
f.close

hsh = Hash.new 0
nodes = doc.css('regveg|veg-level-number:contains("3")') | doc.css('regveg|veg-level-number:contains("4")') |  doc.css('regveg|veg-level-number:contains("5")')
veg=Nokogiri::XML::NodeSet.new(doc,nodes.collect(&:parent))
puts veg.length
(veg.css('regveg|category:contains("Street Vendor")')  | veg.css('regveg|category:contains("Restaurant")')).each do |node|
  parent = node.parent.parent
  statenode = parent.at('regveg|region')
  state= statenode ? statenode.text : nil
  if state.nil?
    state='missing'
  else
    st=STATE_ABBR[state.upcase]
    st=STATE_EXCEPTIONS[parent.at('link').text.split("/").last.to_i] if st.nil?
    puts parent.text if st.nil?
    hsh[st] +=1
  end
end


STATE_ABBR.values.sort.uniq.each do |s|
  puts s + ":" +hsh[s].to_s
end

