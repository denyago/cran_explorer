require 'rails_helper'

RSpec.describe '/packages' do
  subject do
    get '/packages'
    response
  end
  let!(:package) { create(:package) }

  it 'shows Packages available' do
    expect(subject.body).to include(package.name)
  end
end
