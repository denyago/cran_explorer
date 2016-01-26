class Importer
  def initialize(from = 0, to = -1, logger = Rails.logger)
    @index  = RemotePackages.new
    @logger = logger
    @from = from
    @to   = to
  end

  def import!
    time = Benchmark.realtime do
      index.data[from..to].each do |package_data|
        PackageUpdater.new(package_data).update!
      end
    end

    logger.info "Took #{time} sec. to import #{index.data[from..to].size} Packages"
  ensure
    Cleaner.new(index).clear!
  end

  private

  attr_reader :index, :from, :to, :logger
end
