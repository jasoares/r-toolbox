class Package < ApplicationRecord
  extend Forwardable
  has_many :versions
  has_many :maintainers, through: :versions
  has_one :latest_version, -> { order('publication DESC').limit(1) },
    class_name: 'Version'
  has_one :maintainer, through: :latest_version

  def_delegators :latest_version, :authors, :description, :maintainer,
    :publication, :title
  def_delegator :latest_version, :value, :version
end
