require 'vcr'
require 'webmock/rspec'
# Uncomment the line below to allow external requests
# WebMock.allow_net_connect!

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr'
  c.hook_into :webmock
end
