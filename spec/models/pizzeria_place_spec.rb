# frozen_string_literal: true

describe PizzeriaPlace, type: :model do
  describe 'validations' do
    subject { create(:pizzeria_place) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:opens_at) }
    it { is_expected.to validate_presence_of(:closes_at) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  context 'when opening is after closing' do
    let(:opens_at) { Time.parse('20:00') }
    let(:closes_at) { Time.parse('18:00') }
    let(:pizzeria_place) { build(:pizzeria_place, opens_at: opens_at, closes_at: closes_at) }

    it 'raises ActiveRecord::RecordInvalid error' do
      expect { pizzeria_place.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
