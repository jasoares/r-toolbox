module Cran
  class Package
    attr_reader :name, :last_version_value, :server

    def initialize(server, name, last_version_value)
      @server = server
      @name = name
      @last_version_value = last_version_value
    end

    def info_file
      "#{name}/#{server.info_file}"
    end

    def last_version
      Version.new(self, last_version_value)
    end
  end
end
