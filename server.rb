require 'sinatra'
require 'sensi'

def create_thermostat
  thermostat = Sensi::Thermostat.new(ENV['EMAIL'], ENV['PASSWORD'])
  thermostat.connect
  thermostat
end

get '/mode_heat' do
  thermostat = create_thermostat
  success = thermostat.set(mode: 'heat')
  thermostat.disconnect
  if success
    'Succesfully set mode to heat'
  else
    'Failed to set mode to heat'
  end
end

get '/mode_cool' do
  thermostat = create_thermostat
  success = thermostat.set(mode: 'cool')
  thermostat.disconnect
  if success
    'Succesfully set mode to cool'
  else
    'Failed to set mode to cool'
  end
end

get '/mode_off' do
  thermostat = create_thermostat
  success = thermostat.set(mode: 'off')
  thermostat.disconnect
  if success
    'Succesfully set mode to off'
  else
    'Failed to set mode to off'
  end
end

get '/mode' do
  thermostat = create_thermostat
  thermostat.active_mode
end

get '/fan_on' do
  thermostat = create_thermostat
  success = thermostat.set(fan: 'on')
  thermostat.disconnect
  if success
    'Succesfully set fan to on'
  else
    'Failed to set fan to on'
  end
end

get '/fan_auto' do
  thermostat = create_thermostat
  success = thermostat.set(fan: 'on')
  thermostat.disconnect
  if success
    'Succesfully set fan to auto'
  else
    'Failed to set fan to auto'
  end
end

get '/fan' do
  thermostat = create_thermostat
  if thermostat.system_fan_on?
    'Fan is on'
  else
    'Fan is on auto'
  end
end 

get '/temp' do
  thermostat = create_thermostat
  thermostat.system_temperature.to_s
end 

get '/temp_set' do
  thermostat = create_thermostat
  success = thermostat.set(temp: params[:temp])
  if success 
    "Successfully set temperature to #{params[:temp]} degrees Fahrenheit"
  else
  	'Failed to set temperature'
  end
end
