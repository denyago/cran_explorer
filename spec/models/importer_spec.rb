require 'rails_helper'

RSpec.describe Importer do
  let(:instance) { described_class.new }
  let(:index_file_path)   { File.join(Rails.root, 'spec', 'assets', 'PACKAGES_single') }
  let(:package_file_path) { File.join(Rails.root, 'spec', 'assets', 'A3_1.0.0.tar.gz') }
  let(:index_url)   { 'http://cran.r-project.org/src/contrib/PACKAGES' }
  let(:package_url) { 'http://cran.r-project.org/src/contrib/A3_1.0.0.tar.gz' }

  before do
    stub_request(:get, index_url).
      to_return(body: File.open(index_file_path, 'r'), status: 200)
    stub_request(:get, package_url).
      to_return(body: File.open(package_file_path, 'r'), status: 200)
  end

  describe '#import!' do
    subject { instance.import! }

    context 'multiple packages' do
      let(:index_file_path) { File.join(Rails.root, 'spec', 'assets', 'PACKAGES') }

      before do
        allow_any_instance_of(RemotePackage).to receive(:data).and_return({'Date/Publication' => Time.current.to_s})
      end

      it 'adds them all' do
        expect{subject}.to change{Package.count}.from(0).to(149)
      end
    end

    describe 'adds to DB' do
      before {subject}
      let(:package) { Package.last }

      it 'Package' do
        expect(package).to be_present
        expect(package.name).to eq 'A3'
        expect(package.version).to eq '1.0.0'
        expect(package.title).to eq 'Accurate, Adaptable, and Accessible Error Metrics for Predictive Models'
        expect(package.description).to eq 'Supplies tools for tabulating and analyzing the results of predictive models. The methods employed are applicable to virtually any predictive model and make comparisons between different methodologies straightforward.'
        expect(package.date_publication).to eq DateTime.parse('2015-08-16 23:05:52')
      end

      it 'authors' do
        expect(package.authors.size).to eq 1
      end

      it 'maintainers' do
        expect(package.maintainers.size).to eq 1
      end
    end

    context 're-imported' do
      before { described_class.new.import! }

      context 'same version' do
        describe 'changes nothing' do
          it { expect{subject}.to_not change{Package.count}.from(1) }
          it { expect{subject}.to_not change{Person.count}.from(1) }
        end
      end

      context 'different version' do

        let(:other_package_url) { 'http://cran.r-project.org/src/contrib/A3_1.0.1.tar.gz' }
        let(:other_index_file_path)   { File.join(Rails.root, 'spec', 'assets', 'PACKAGES_single_2') }

        before do
          stub_request(:get, index_url).
            to_return(body: File.open(other_index_file_path, 'r'), status: 200)
          stub_request(:get, other_package_url).
            to_return(body: File.open(package_file_path, 'r'), status: 200)
        end

        it 'adds a new Package with new data' do
          expect{subject}.to change{Package.count}.from(1).to(2)
          expect(Package.last.version).to eq '1.0.1'
        end
      end
    end
  end
end
