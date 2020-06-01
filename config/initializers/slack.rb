Slack.configure do |config|
  config.token = ENV['slack_api_token'] if ENV['using_slack_as_output']
end