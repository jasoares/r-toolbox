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
      parser = DebianControlParser.new(response.body)
      packages = []
      parser.paragraphs do |p|
        name, version = nil, nil
        p.fields do |key, value|
          name ||= value if key == 'Package'
          version ||= value if key == 'Version'
          break if name && version
        end
        packages << Package.new(self, name, version)
      end
      packages
    end
  end
end
