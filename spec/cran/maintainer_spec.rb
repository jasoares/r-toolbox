require 'cran'

module Cran
  describe Maintainer do
    describe '::from_string' do
      context "given a maintainer string with 'ORPHANED'" do
        let(:maintainer_str) { 'ORPHANED'}

        it "instantiates a Maintainer with name 'ORPHANED'" do
          expect(Maintainer.from_string(maintainer_str).name).to eq('ORPHANED')
        end

        it "instantiates a Maintainer with email 'no-maintainer@r-project.org'" do
          expect(Maintainer.from_string(maintainer_str).email).to eq('no-maintainer@r-project.org')
        end
      end

      context "given a maintainer string with 'Scott Fortmann-Roe <scottfr@berkeley.edu>'" do
        let(:maintainer_str) { 'Scott Fortmann-Roe <scottfr@berkeley.edu>' }

        it "instantiates a Maintainer with name 'Scott Fortmann-Roe'" do
          expect(Maintainer.from_string(maintainer_str).name).to eq('Scott Fortmann-Roe')
        end

        it "instantiates a Maintainer with email 'scottfr@berkeley.edu'" do
          expect(Maintainer.from_string(maintainer_str).email).to eq('scottfr@berkeley.edu')
        end
      end
    end
  end
end
