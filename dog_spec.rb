# frozen_string_literal: true

require_relative './dog'

RSpec.describe Dog do
  describe '#write_log' do
    dog = Dog.new
    it { expect(dog.write_log('chihuahua', 'C:/aaa')).to eql nil }
  end

  describe '#get_image_from_api' do
    let(:breed) { 'chihuahua' }
    let(:breed_url) { "https://dog.ceo/api/breed/#{breed}/images/random" }
    let(:breed_response) { instance_double(HTTParty::Response, body: breed_response_body) }
    let(:breed_response_body) { 'response_body' }

    before do
      allow(HTTParty).to receive(:get).and_return(breed_response)
      allow(JSON).to receive(:parse)
      dog = Dog.new
      dog.get_image_from_api('chihuahua')
    end

    it 'fetches the repos from breed api' do
      expect(HTTParty).to have_received(:get).with(breed_url)
    end

    it 'parses the breed response' do
      expect(JSON).to have_received(:parse).with(breed_response_body)
    end
  end
end
