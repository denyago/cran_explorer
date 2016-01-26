require 'rails_helper'

RSpec.describe 'Status endpoint' do
  subject do
    get '/'
    response
  end

  it 'returns HTTP OK' do
    expect(subject.status).to eq 200
  end

  it 'returns text' do
    expect(subject.body).to eq 'UP'
  end
end
