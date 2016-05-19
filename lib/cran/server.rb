module Cran
  class Server
    INFO_FILE = 'DESCRIPTION'.freeze
    LIST_URL = 'https://cran.r-project.org/src/contrib/PACKAGES'.freeze

    attr_reader :list_url, :info_file

    def initialize(list_url = LIST_URL, info_file = INFO_FILE)
      @list_url, @info_file = list_url, info_file
    end

    def packages
      response = HTTParty.get(list_url)
      Dcf.parse(response.body).map do |pkg|
        Package.new self, pkg['Package'], pkg['Version']
      end
    end
  end
end
