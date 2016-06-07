module Cran
  class Author
    attr_reader :name, :roles

    # Regexp used to split authors string into separate authors propperly
    # by either commas or 'and'. In the case of the commas we need to be extra
    # careful for the fact that some strings contain roles inside brackets that
    # when an author as multiple roles may also have commas separating them.
    # Notice the following example:
    # "Csillery Katalin [aut, cre], Lemaire Louisiane [aut], Francois Olivier [aut] and Blum Michael [aut, cre]"
    AUTHORS_SPLIT_REGEX = /,(?![\s\w]+(?:\]|\)))|(?:\sand\s)/i
    AUTHOR_NAME_REGEX = /\A([^\[]+)/
    AUTHOR_ROLES_REGEX = /(\s?\[[^\]]+\])/i

    def initialize(name, roles)
      @name = name
      @roles = roles
    end

    def author?
      !!roles[/aut/] if roles
    end

    def contributor?
      !!roles[/ctb/] if roles
    end

    def copyright_holder?
      !!roles[/cph/] if roles
    end

    def creator?
      !!roles[/cre/] if roles
    end

    def self.from_string(authors_str)
      authors_str.split(AUTHORS_SPLIT_REGEX).map do |author_str|
        name = $1.strip if author_str.match(AUTHOR_NAME_REGEX)
        roles = $1.strip if author_str.match(AUTHOR_ROLES_REGEX)
        Author.new(name, roles)
      end
    end
  end
end
