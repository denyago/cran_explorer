require 'open-uri'

class Downloader
  attr_reader :file

  def initialize(url)
    @file = Tempfile.new('PACKAGES', Dir.mktmpdir)
    @url  = url
  end

  def download!
    File.open(file.path, 'wb') do |saved_file|
      open(url, 'rb') do |read_file|
        saved_file.write(read_file.read)
      end
    end

    self
  end

  private

  attr_reader :url
end
