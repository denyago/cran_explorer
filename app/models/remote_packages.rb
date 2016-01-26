class RemotePackages
  include Memoizable

  INDEX_URL = 'http://cran.r-project.org/src/contrib/PACKAGES'

  def initialize
    @downloader = Downloader.new(INDEX_URL)
  end

  def data
    Dcf.parse(File.read(file))
  end
  memoize :data

  def file
    @file ||= downloader.download!.file
  end

  def has_file?
    @file.present?
  end

  private

  attr_reader :downloader
end
