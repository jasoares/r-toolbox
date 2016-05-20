class Version < ApplicationRecord
  belongs_to :maintainer
  belongs_to :package

  scope :latest, -> { order('publication DESC').limit(1) }
end
