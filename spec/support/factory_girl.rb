require 'factory_girl_rails'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    begin
      FactoryGirl.lint
      DatabaseCleaner.clean_with(:truncation)
    rescue => e
      STDERR.puts "Error checking FactoryGirl factories!"
      STDERR.puts e.to_s
      exit 1
    end
  end
end
