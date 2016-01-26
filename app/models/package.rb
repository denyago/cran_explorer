class Package < ActiveRecord::Base
  has_many :package_authors
  has_many :authors, through: :package_authors, source: :person

  has_many :package_maintainers
  has_many :maintainers, through: :package_maintainers, source: :person
end
