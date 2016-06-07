class Version < ApplicationRecord
  belongs_to :maintainer
  has_many :collaborations
  has_many :authors, through: :collaborations
  belongs_to :package

  scope :latest, -> { order('publication DESC').limit(1) }
end
