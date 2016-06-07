require 'active_support/core_ext/hash'

module Cran
  class Version
    extend Forwardable

    INFO_MAPPING = {
      'Author' => 'authors_str',
      'Date/Publication' => 'publication_str',
      'Description' => 'description',
      'Maintainer' => 'maintainer_str',
      'Title' => 'title'
    }

    def_delegators :@package, :name, :info_file

    attr_reader :description, :maintainer_str, :package,
      :publication_str, :title, :value

    def initialize(package, value)
      @package = package
      @value = value
      @fetched = false
    end

    INFO_MAPPING.values.each do |v|
      define_method(:"#{v}") do
        fetch unless fetched?
        instance_variable_get :"@#{v}"
      end
    end

    def authors
      Author.from_string(authors_str)
    end

    # if I had more time I would try to make this more failsafe,
    # maybe rescuing #first possibility of error
    # The chosen gem tree-top-dcf does not allow to select which fields to parse
    # and is really slow parsing the packages
    def fetch
      parser = DebianControlParser.new self.class.fetch_description(url, info_file)
      parser.fields do |name, value|
        instance_variable_set :"@#{INFO_MAPPING[name]}", value if INFO_MAPPING[name]
      end
      @fetched = true
    end

    def fetched?
      !!@fetched
    end

    def maintainer
      Maintainer.from_string(maintainer_str)
    end

    # parsing of dates need to be addressed before releasing to make sure it is
    # UTC
    def publication
      publication_str ? DateTime.parse(publication_str) : publication_str
    end

    def reload
      fetch
    end

    def reset!
      INFO_MAPPING.values.each do |method|
        remove_instance_variable method.to_sym
      end
      @fetched = false
    end

    def to_hash
      fetch unless fetched?
      {
        authors: authors,
        publication: publication,
        description: description,
        maintainer: maintainer,
        title: title
      }
    end

    def url
      "http://cran.r-project.org/src/contrib/#{name}_#{value}.tar.gz"
    end

    def self.fetch_description(url, info_file)
      `curl -s #{url} | tar -xzO #{info_file}`
        .encode('UTF-8', invalid: :replace, replace: '?')
    end
  end
end
