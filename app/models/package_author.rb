class PackageAuthor < ActiveRecord::Base
  belongs_to :package
  belongs_to :person
end
