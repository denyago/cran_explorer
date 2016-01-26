require 'rails_helper'

RSpec.describe Importer do
  let(:instance) { described_class.new }
  let(:test_file_path) { File.join(Rails.root, 'spec', 'assets', 'PACKAGES_single') }

  before do
    stub_request(:get, Downloader::INDEX_URL).
      to_return(body: File.open(test_file_path, 'r'), status: 200)
  end

  describe '#import!' do
    subject { instance.import! }

    context 'multiple packages' do
      let(:test_file_path) { File.join(Rails.root, 'spec', 'assets', 'PACKAGES') }

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
        #expect(package.date_publication).to eq Time.now # TODO: Fix it
        #expect(package.title).to eq 'TODO: Fix me' # TODO
        #expect(package.description).to eq 'TODO: Fix me' # TODO
      end

      xit 'authors' do
        expect(package.authors.size).to eq 2
        expect(package.authors.order(:name).as_json).to eq [{foo: :bar}, {foo: :bar}]
      end

      xit 'maintainers' do
        expect(package.maintainers.size).to eq 1
        expect(package.maintainers.order(:name).as_json).to eq [{foo: :bar}]
      end
    end

    context 're-imported' do
      context 'same version' do
        xit 'changes nothing' do

        end
      end

      context 'different version' do
        xit 'adds a new Package with new data' do

        end
      end
    end
  end
end
