require 'rails_helper'

describe Package do
  context 'given a package with two versions' do
    let(:package) { create(:version, publication: 3.days.ago).package }
    let(:last_version) { build(:version, publication: 1.day.ago) }

    before do
      package.versions << last_version
    end

    describe '#latest_version' do
      it 'returns the last version released' do
        expect(package.latest_version.value).to eq(last_version.value)
      end
    end
  end

  context 'given a persisted package with a version' do
    let(:package) { create(:version).package }

    describe '#authors' do
      it 'delegates to Version#authors' do
        expect(package.latest_version).to receive(:authors)
        package.authors
      end
    end

    describe '#description' do
      it 'delegates to Version#description' do
        expect(package.latest_version).to receive(:description)
        package.description
      end
    end

    describe '#maintainer' do
      it 'delegates to Version#maintainer' do
        expect(package.latest_version).to receive(:maintainer)
        package.maintainer
      end
    end

    describe '#publication' do
      it 'delegates to Version#publication' do
        expect(package.latest_version).to receive(:publication)
        package.publication
      end
    end

    describe '#title' do
      it 'delegates to Version#title' do
        expect(package.latest_version).to receive(:title)
        package.title
      end
    end

    describe '#version' do
      it 'delegates to Version#value' do
        expect(package.latest_version).to receive(:value)
        package.version
      end
    end
  end
end
