require 'sinatra'
require 'sensi'

thermostat = Sensi::Thermostat.new(ENV['EMAIL'], ENV['PASSWORD'])
thermostat.connect

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

get '/status' do
  thermostat = Sensi::Thermostat.new(ENV['EMAIL'], ENV['PASSWORD'])
  thermostat.connect
  status = "The room is currently #{thermostat.temperature} degrees with a humidity of #{thermostat.humidity}. "
  if thermostat.active_mode != 'Off'
    status += "The AC has been active on the #{thermostat.active_mode} mode for #{string_rep_of_time(thermostat.active_time)}. "
  else
    status += "The AC is currently not active. "
  end
  if thermostat.system_mode != 'Off'
    status += "The thermostat is set to the #{thermostat.system_mode} mode with a temperature of #{thermostat.system_temperature.to_s} degrees and the fan on" 
  else
    status += "The thermostat is set to the Off mode and the fan on" 
  end
  if !thermostat.system_fan_on?
    status += ' auto'
  end
  status += '. What would you like to do?'
  status
end

get '/mode_heat' do
  success = thermostat.set(mode: 'heat')
  if success
    'Succesfully set mode to heat'
  elsif thermostat.system_mode == 'Heat'
    'Mode is already set to Heat'
  else
    'Failed to set mode to heat'
  end
end

get '/mode_cool' do
  success = thermostat.set(mode: 'cool')
  if success
    'Succesfully set mode to cool'
  elsif thermostat.system_mode == 'Cool'
    'Mode is already set to Cool'
  else
    'Failed to set mode to cool'
  end
end

get '/mode_off' do
  success = thermostat.set(mode: 'off')
  if success
    'Succesfully set mode to off'
  elsif thermostat.system_mode == 'Off'
    'Mode is already set to Off'
  else
    'Failed to set mode to off'
  end
end

get '/fan_on' do
  success = thermostat.set(fan: 'on')
  if success
    'Succesfully set fan to on'
  elsif thermostat.system_fan_on?
    'Fan is already set to on'
  else
    'Failed to set fan to on'
  end
end

get '/fan_off' do
  success = thermostat.set(fan: 'auto')
  if success
    'Succesfully set fan to auto'
  elsif !thermostat.system_fan_on?
    'Fan is already set to auto'
  else
    'Failed to set fan to auto'
  end
end

get '/temp_set' do
  if thermostat.system_mode == 'Off'
    return 'Thermostat is off'
  end
  success = thermostat.set(temp: params[:temp])
  if success 
    "Successfully set temperature to #{params[:temp]} degrees"
  elsif thermostat.system_temperature == params[:temp]
    "Temperature is already set to #{params[:temp]} degrees"
  else
  	'Failed to set temperature'
  end
end
