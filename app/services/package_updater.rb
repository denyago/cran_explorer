class PackageUpdater
  require_relative 'package_updator/person_extractor'

  include Memoizable

  def initialize(initial_package_data)
    @initial_package_data = initial_package_data
    @remote_package       = RemotePackage.new(name, version)
  end

  def update!
    return true if Package.where(name: name, version: version).any?

    begin
      package = Package.create!(
        name:    name,
        version: version,
        title:   title,
        description:      description,
        date_publication: date_publication
      )
      maintainers.each do |maintainer|
        PackageMaintainer.find_or_create_by!(package_id: package.id, person_id: maintainer.id)
      end
      authors.each do |author|
        PackageAuthor.find_or_create_by!(package_id: package.id, person_id: author.id)
      end
    ensure
      Cleaner.new(remote_package).clear!
    end
  end

  private

  attr_reader :initial_package_data, :remote_package

  def version
    initial_package_data['Version']
  end

  def name
    initial_package_data['Package']
  end

  def title
    remote_package_data['Title']
  end

  def description
    remote_package_data['Description']
  end

  def date_publication
    DateTime.parse remote_package_data['Date/Publication']
  end

  def maintainers
    @maintainers ||= PersonExtractor.new(remote_package_data['Maintainer']).people
  end

  def authors
    @authors ||= PersonExtractor.new(remote_package_data['Author']).people
  end

  def remote_package_data
    remote_package.data
  end
  memoize :remote_package_data
end
