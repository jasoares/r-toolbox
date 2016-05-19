require 'cran'

module Cran
  describe Package do
    let(:server) { Server.new }
    let(:package) { Package.new server, 'A3', '1.0.0' }

    describe '#name' do
      it 'returns the name of the package' do
        expect(package.name).to eq('A3')
      end
    end

    describe '#info_file' do
      context 'given the default origin server' do
        it "returns 'A3/DESCRIPTION'" do
          expect(package.info_file).to eq('A3/DESCRIPTION')
        end
      end

      context 'given a custom origin server' do
        let(:server) { Server.new 'https://cran-server.org', 'INFO'}
        it "returns 'A3/INFO'" do
          expect(package.info_file).to eq('A3/INFO')
        end
      end
    end

    describe '#last_version_value' do
      it 'returns the version value' do
        expect(package.last_version_value).to eq('1.0.0')
      end
    end

    describe '#server' do
      it 'returns the origin server' do
        expect(package.server).to eq(server)
      end
    end

    describe 'last_version' do
      it 'returns a version instance' do
        expect(package.last_version).to be_a Version
      end

      it 'returns a version instance with the last version value' do
        expect(package.last_version.value).to eq(package.last_version_value)
      end
    end
  end
end
