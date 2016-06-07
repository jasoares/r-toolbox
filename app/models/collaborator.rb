class Collaborator < ApplicationRecord
  has_many :collaborations
  has_many :versions, through: :collaborations
end
