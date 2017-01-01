def string_rep_of_time(string)
  portions = string.split(':')
  time_units = ['hours', 'minutes', 'seconds']
  array = [0, 0, 0]
  counter = 0
  portions.each_with_index do |portion, index|
  	if portion != '00'
      counter += 1
      array[index] = 1
  	end
  end
  if counter == 3
  	return "#{portions[0].to_i} #{time_units[0]}, #{portions[1].to_i} #{time_units[1]}, and #{portions[2].to_i} #{time_units[2]}"
  elsif counter == 1 || counter == 2
  	time_string = ''
  	array.each_with_index do |ele, index|
  	  if ele == 1
  	  	time_string += "#{portions[index].to_i} #{time_units[index]}"
  	  	if counter == 1
  	  	  return time_string
  	  	elsif counter == 2 && !time_string.include?('and')
  	  	  time_string += ' and '
  	  	end
  	  end
  	end
  	return time_string
  else
  	'0 seconds'
  end
end

puts string_rep_of_time('50:00:00')