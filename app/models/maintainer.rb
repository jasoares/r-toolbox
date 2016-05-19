class Maintainer < ApplicationRecord
  has_many :versions
  has_many :packages, through: :versions
end
