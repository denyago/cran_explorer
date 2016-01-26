class Person < ActiveRecord::Base
  has_many :package_authors
  has_many :package_maintainers
end
