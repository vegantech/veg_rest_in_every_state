current=`sh grep_data.sh |sort`.split("\n")
orig= File.read("original_state_list_sorted").split("\n")

current.each_with_index do |c,idx|
  state,cur = c.split(":")
  diff = cur.to_i - orig[idx].split(":")[1].to_i
  if diff.zero?
    diffs=""
  elsif diff.abs == diff
    diffs ="<span style=\"color:green\">+#{diff}</span>"
  else
    diffs ="<span style=\"color:red\">#{diff}</span>"
  end
  puts c + " " + diffs
end


