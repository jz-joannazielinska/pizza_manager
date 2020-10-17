# frozen_string_literal: true

describe Pizza, type: :model do
  describe 'validations' do
    subject { create(:pizza) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
