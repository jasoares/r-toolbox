require 'cran'
require 'byebug'

module Cran
  describe Version do
    let(:server)  { Server.new }
    let(:package) { Package.new server, 'A3', '1.0.0' }
    context 'given a sample A3 v1.0.0 version' do
      let(:version) { Version.new package, '1.0.0' }

      describe '#name' do
        it 'delegates the call to package' do
          expect(version.package).to receive(:name).and_call_original
          version.name
        end
      end

      describe '#value' do
        it "returns '1.0.0'" do
          expect(version.value).to eq('1.0.0')
        end
      end

      describe '#url' do
        it "returns 'http://cran.r-project.org/src/contrib/A3_1.0.0.tar.gz'" do
          expect(version.url).to eq('http://cran.r-project.org/src/contrib/A3_1.0.0.tar.gz')
        end
      end

      describe '#info_file' do
        it 'delegates the call to package' do
          expect(version.package).to receive(:info_file).and_call_original
          version.info_file
        end
      end

      context 'given a sample description content' do
        let(:description_content) do
          <<~eos
            Package: A3
            Type: Package
            Title: Accurate, Adaptable, and Accessible Error Metrics for Predictive Models
            Version: 1.0.0
            Date: 2015-08-15
            Author: Scott Fortmann-Roe
            Maintainer: Scott Fortmann-Roe <scottfr@berkeley.edu>
            Description: Supplies tools for tabulating and analyzing the results of predictive models. The methods employed are applicable to virtually any predictive model and make comparisons between different methodologies straightforward.
            License: GPL (>= 2)
            Depends: R (>= 2.15.0), xtable, pbapply
            Suggests: randomForest, e1071
            NeedsCompilation: no
            Packaged: 2015-08-16 14:17:33 UTC; scott
            Repository: CRAN
            Date/Publication: 2015-08-16 23:05:52
          eos
        end

        describe '::fetch_description' do
          it 'it executes curl and tar with the passed arguments' do
            expect(Version).to receive(:`)
              .with('curl -s http://cran.r-project.org/src/contrib/A3_1.0.0.tar.gz | tar -xO A3/DESCRIPTION')
              .and_return(description_content)
            Version.fetch_description('http://cran.r-project.org/src/contrib/A3_1.0.0.tar.gz', 'A3/DESCRIPTION')
          end
        end

        describe '#maintainer' do
          context 'given a valid description content is loaded' do
            before(:each) do
              allow(Version).to receive(:fetch_description).and_return(description_content)
            end

            it 'returns an instance of Maintainer' do
              expect(version.maintainer).to be_a Maintainer
            end

            it 'delegates instantiation to Maintainer::from_string' do
              expect(Maintainer).to receive(:from_string).with(version.maintainer_str)
              version.maintainer
            end
          end
        end

        describe '#fetch' do
          it 'relies on version info to get the data' do
            expect(Version).to receive(:fetch_description).and_return(description_content)
            version.fetch
          end

          context 'given a valid description content is loaded' do
            before(:each) do
              allow(Version).to receive(:fetch_description).and_return(description_content)
            end

            it 'uses DebianControlParser for parsing version info' do
              parser = double(DebianControlParser, fields: enum_for(:each))
              expect(DebianControlParser).to receive(:new)
                .with(description_content).and_return(parser)
              version.fetch
            end

            it 'changes the state of version to fetched' do
              expect { version.fetch }.to change { version.fetched? }.from(false).to(true)
            end

            it 'sets the instance variable @authors' do
              expect { version.fetch }.to change {
                version.send(:instance_variable_get, :@authors)
              }.from(nil).to('Scott Fortmann-Roe')
            end

            it 'sets the instance variable @publication_str' do
              expect { version.fetch }.to change {
                version.send(:instance_variable_get, :@publication_str)
              }.from(nil).to('2015-08-16 23:05:52')
            end

            it 'sets the instance variable @description' do
              expect { version.fetch }.to change {
                version.send(:instance_variable_get, :@description)
              }.from(nil).to('Supplies tools for tabulating and analyzing the results of predictive models. The methods employed are applicable to virtually any predictive model and make comparisons between different methodologies straightforward.')
            end

            it 'sets the instance variable @maintainer_str' do
              expect { version.fetch }.to change {
                version.send(:instance_variable_get, :@maintainer_str)
              }.from(nil).to('Scott Fortmann-Roe <scottfr@berkeley.edu>')
            end

            it 'sets the instance variable @title' do
              expect { version.fetch }.to change {
                version.send(:instance_variable_get, :@title)
              }.from(nil).to("Accurate, Adaptable, and Accessible Error Metrics for Predictive Models")
            end
          end
        end
      end
    end
  end
end
