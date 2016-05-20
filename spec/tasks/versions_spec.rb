require 'rails_helper'
require 'cran'
require 'rake'

describe 'versions:load' do
  let(:rake)      { Rake::Application.new }
  let(:task_name) { self.class.top_level_description }
  let(:task_path) { "lib/tasks/#{task_name.split(":").first}" }
  subject         { rake[task_name] }

  def loaded_files_excluding_current_rake_file
    $".reject { |file| file == Rails.root.join("#{task_path}.rake").to_s }
  end

  before do
    Rake.application = rake
    Rake.application.rake_require(task_path, [Rails.root.to_s], loaded_files_excluding_current_rake_file)

    Rake::Task.define_task(:environment)
  end

  after do
    subject.reenable
  end

  context 'given an empty database and 3 valid packages' do
    before do
      allow(Cran::Version).to receive(:fetch_description).and_return(
        File.read("#{Rails.root}/spec/vcr/cran/A3_DESCRIPTION"),
        File.read("#{Rails.root}/spec/vcr/cran/abbyyR_DESCRIPTION"),
        File.read("#{Rails.root}/spec/vcr/cran/abc_DESCRIPTION")
      )
    end

    around(:each) do |example|
      VCR.use_cassette 'cran/3_packages' do
        example.run
      end
    end

    it 'creates 3 new packages' do
      expect { subject.invoke }.to change { Package.count }.from(0).to(3)
    end

    it 'creates 3 new maintainers' do
      expect { subject.invoke }.to change { Maintainer.count }.from(0).to(3)
    end

    it 'creates 3 new versions' do
      expect { subject.invoke }.to change { Version.count }.from(0).to(3)
    end

    context 'given there is an updated version' do
      before do
        subject.tap(&:invoke).reenable
      end

      around(:each) do |example|
        VCR.use_cassette 'cran/3_packages_with_new_version' do
          example.run
        end
      end

      it 'does not create new packages' do
        expect { subject.invoke }.not_to change { Package.count }.from(3)
      end

      it 'does not create new maintainers' do
        expect { subject.invoke }.not_to change { Maintainer.count }.from(3)
      end

      it 'creates a new version' do
        expect { subject.invoke }.to change { Version.count }.from(3).to(4)
      end
    end
  end
end
