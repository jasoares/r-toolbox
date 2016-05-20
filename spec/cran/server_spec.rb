require 'cran'
require 'webmock/rspec'
require 'vcr'

module Cran
  describe Server do
    let(:server) { Server.new }

    describe '#packages' do
      context 'given a list of 50 packages' do
        around(:each) do |example|
          VCR.use_cassette 'cran/50_packages' do
            example.run
          end
        end

        it "performs a GET request to https://cran.r-project.org/src/contrib/PACKAGES" do
          server.packages
          expect(WebMock).to have_requested(
            :get, "https://cran.r-project.org/src/contrib/PACKAGES"
          ).once
        end

        it 'parses the request response using DebianControlParser' do
          response = double('Response', body: '')
          allow(HTTParty).to receive(:get).with(Server::LIST_URL).and_return(response)
          expect(DebianControlParser).to receive(:new).with(response.body).and_call_original
          server.packages
        end

        it 'returns a list of 50 elements' do
          expect(server.packages.size).to equal 50
        end

        it 'returns instances of Package' do
          expect(server.packages).to all(be_an(Package))
        end
      end
    end
  end
end
