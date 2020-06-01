# These jobs actually do the work commanded from the controller.
# That way the controller responds with a quick 'OK', making that request
# fast for the client and the actual job can take longer.

# These jobs could take 10-20 seconds to complete so
# you don't want to hold up the invocation request the whole time

class TeslaHvacJob < ApplicationJob
  class_timeout 30

  def start_hvac
    client = Slack::Web::Client.new
    begin
      tesla_api = TeslaApi::Client.new(
        email: ENV['tesla_email_address'], 
        client_id: ENV['tesla_api_client_id'], 
        client_secret: ENV['tesla_api_client_secret']
      )
      tesla_api.login!(ENV['tesla_password'])
      # If you have several Tesla vehicles, you'd choose which one here
      my_tesla_vehicle = tesla_api.vehicles.first
      my_tesla_vehicle.wake_up
      
      # check to see if the car is awake yet
      # the car wont accept the hvac commands while asleep
      15.times {
        puts "car state is #{my_tesla_vehicle['state']}"
        if my_tesla_vehicle['state'] == 'online'
          puts 'turning on car'
          my_tesla_vehicle.auto_conditioning_start unless my_tesla_vehicle.climate_state['is_auto_conditioning_on']
          # client.chat_postMessage(channel: ENV['slack_channel_name'], text: 'Tesla HVAC started', as_user: true) if ENV['using_slack_as_output']
          return
        else
          puts 'sleeping'
          sleep 2
          # Refresh the vehicle state
          my_tesla_vehicle = tesla_api.vehicles.first
        end
      }
      # If we're not in this loop, the car didn't wake up after several attempts
      throw 'Car did not wake up after several attempts'
    rescue => e
      client.chat_postMessage(channel: ENV['slack_channel_name'], text: "Tesla HVAC script failed: #{e.inspect} #{e.backtrace.join("\n")}", as_user: true) if ENV['using_slack_as_output']
    end
  end

  def stop_hvac
    client = Slack::Web::Client.new
    begin
      tesla_api = TeslaApi::Client.new(
        email: ENV['tesla_email_address'], 
        client_id: ENV['tesla_api_client_id'], 
        client_secret: ENV['tesla_api_client_secret']
      )
      tesla_api.login!(ENV['tesla_password'])
      # If you have several Tesla vehicles, you'd choose which one here
      my_tesla_vehicle = tesla_api.vehicles.first
      my_tesla_vehicle.wake_up
      my_tesla_vehicle.auto_conditioning_stop unless my_tesla_vehicle.climate_state["is_auto_conditioning_off"]
  
      client.chat_postMessage(channel: ENV['slack_channel_name'], text: 'Tesla HVAC stopped', as_user: true) if ENV['using_slack_as_output']
      return
    rescue => e
      client.chat_postMessage(channel: ENV['slack_channel_name'], text: "Tesla HVAC script failed: #{e.inspect} #{e.backtrace.join("\n")}", as_user: true) if ENV['using_slack_as_output']
      return
    end
  end
end
