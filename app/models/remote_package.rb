require 'zlib'
require 'archive/tar/minitar'

class RemotePackage
  include Memoizable
  include Archive::Tar

  PACKAGE_URL = 'http://cran.r-project.org/src/contrib/[package_name]_[package_version].tar.gz'

  def initialize(name, version)
    url = make_url(name, version)
    @name = name
    @downloader = Downloader.new(url)
  end

  def data
    Dcf.parse(normalized_text).first
  end
  memoize :data

  def file
    @file ||= downloader.download!.file
  end

  def has_file?
    @file.present?
  end

  def description_file
    @description_file ||= extract_archive
  end

  private

  attr_reader :downloader, :name

  def make_url(name, version)
    PACKAGE_URL.
      gsub('[package_name]', name).
      gsub('[package_version]', version)
  end

  def normalized_text
    string = File.read(description_file)
    # Will raise error if string has malformed characters like \xE9
    # See also http://ruby-doc.org/core-1.9.3/String.html#method-i-encode
    string.encode('UTF-8', 'binary')
    string
  rescue Encoding::InvalidByteSequenceError,
         Encoding::UndefinedConversionError
    string.force_encoding('iso-8859-1').encode('utf-8')
  end

  def extract_archive
    workdir = File.dirname(file.path)
    cmd = "cd #{workdir} && tar -zxvf ./#{File.basename(file.path)} #{name}/DESCRIPTION"
    `#{cmd}`

    file_path = File.join(workdir, name, 'DESCRIPTION')
    raise "Can't find DESCRIPTION file at #{file_path}" unless File.exists?(file_path)
    File.open(file_path, 'r')
  end
end
