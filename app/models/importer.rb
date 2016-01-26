require 'dcf'

class Importer
  def initialize(downloader = Downloader.new)
    @downloader = downloader
  end

  def import!
    packages_file = downloader.download_index!.file
    parsed_data = Dcf.parse(File.read(packages_file))

    parsed_data.each do |package_data|
      # TODO: Add versioning support
      package = Package.create!(name: package_data['Package'],
                                version: package_data['Version'])
    end
  end

  private

  attr_reader :downloader
end
