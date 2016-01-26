class Cleaner
  def initialize(cleanable)
    @cleanable = cleanable
  end

  def clear!
    if should_clean?
      dir = File.dirname(path)
      FileUtils.rm_r(dir)
    end
  end

  private

  attr_reader :cleanable

  def path
    cleanable.file.path
  end

  def should_clean?
    cleanable.has_file? && File.exists?(path)
  end
end
