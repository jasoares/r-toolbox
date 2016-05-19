module Cran
  # Package Maintainer class
  class Maintainer
    attr_reader :name, :email

    def initialize(name, email)
      @name, @email = name, email
    end

    def self.from_string(maintainer_str)
      if /ORPHANED/i.match(maintainer_str)
        m_name, m_email = 'ORPHANED', 'no-maintainer@r-project.org'
      else
        m_name, m_email = /([^\<]+)\<([^\>]+)\>/.match(maintainer_str).captures
          .map(&:strip)
      end
      new(m_name, m_email)
    end
  end
end
