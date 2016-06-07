require 'cran'

class MigrateAuthorsFromVersions < ActiveRecord::Migration[5.0]
  class ::Version < ApplicationRecord
  end

  def up
    # Routine to migrate data to the new format
    Version.select(:id, :authors).offset(6300).each do |version|
      next if version.authors.nil?
      sanitized_authors = version.authors.gsub("\n", '')
      authors = Cran::Author.from_string(sanitized_authors)
      authors[0..10].each do |author|
        collaborator = Collaborator.find_or_create_by!(name: author.name)
        puts version.id, collaborator.id, author.name
        Collaboration.find_or_create_by!(
          version: version,
          collaborator: collaborator,
          author: author.author?,
          contributor: author.contributor?,
          copyright_holder: author.copyright_holder?,
          creator: author.creator?
        )
      end
    end

    remove_column :versions, :authors
  end
end
