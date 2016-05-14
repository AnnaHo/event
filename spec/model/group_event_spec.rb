require 'rails_helper'

describe GroupEvent, 'Validations', :type => :model do
  context "published?" do
    before { allow(subject).to receive(:published?).and_return(true) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description)}
    it { is_expected.to validate_presence_of(:location)}
    it { is_expected.to validate_presence_of(:start_date)}
    it { is_expected.to validate_presence_of(:end_date)}
  end
end