source "https://rubygems.org"

ruby '2.5.8'

gem "jets"
gem "dynomite"
gem 'tesla_api'
gem 'slack-ruby-client'

# development and test groups are not bundled as part of the deployment
group :development, :test do
  # Pinning byebug and puma to versions because AWS only has certain versions
  # of these gems. More info here: https://github.com/tongueroo/jets/issues/474

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '11.1.2', platforms: [:mri, :mingw, :x64_mingw]
  gem 'shotgun'
  gem 'rack'
  gem 'puma', '4.3.3'
  gem 'pry'
end

group :test do
  gem 'rspec' # rspec test group only or we get the "irb: warn: can't alias context from irb_context warning" when starting jets console
  gem 'launchy'
  gem 'capybara'
end
