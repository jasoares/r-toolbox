class Package < ApplicationRecord
  has_many :versions
  has_many :maintainers, through: :versions
end
