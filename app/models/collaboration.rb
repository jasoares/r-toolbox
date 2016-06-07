class Collaboration < ApplicationRecord
  belongs_to :collaborator
  belongs_to :version
end
