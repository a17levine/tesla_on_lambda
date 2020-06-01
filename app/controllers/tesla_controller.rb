# We use this controller as our public endpoint
# It asynchronously runs the jobs which could take 10-20 seconds to fulfill
# This way, we don't hold up request/response for the work since it takes a while
# Siri or whatever client will get a quick response

class TeslaController < ApplicationController
  
  timeout 30
  iam_policy 'lambda'
  def start_hvac
    TeslaHvacJob.perform_later(:start_hvac)
    render json: { status: 'HVAC started' } and return
  end
  
  timeout 30
  iam_policy 'lambda'
  def stop_hvac
    TeslaHvacJob.perform_later(:stop_hvac)
    render json: { status: 'HVAC stopped' } and return
  end
end
