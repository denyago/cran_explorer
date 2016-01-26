require 'open-uri'

class Downloader
  INDEX_URL   = 'http://cran.r-project.org/src/contrib/PACKAGES'
  PACKAGE_URL = 'http://cran.r-project.org/src/contrib/[package_name]_[package_version].tar.gz'

  attr_reader :file

  def initialize
    @file = Tempfile.new('PACKAGES')
  end

  def download_index!
    File.open(file.path, 'wb') do |saved_file|
      open(INDEX_URL, 'rb') do |read_file|
        saved_file.write(read_file.read)
      end
    end

    self
  end
end
