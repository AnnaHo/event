require 'rails_helper'

describe GroupEvent, 'Validations', :type => :model do
  
  it { is_expected.to validate_presence_of(:status)}
  
  it 'does not allow start date to be after end date' do
    start_date = DateTime.now
    end_date = start_date - 1.days
    group_event = GroupEvent.new(name: "an event", status: "draft", start_date: start_date, end_date: end_date)
    expect(group_event.valid?).to be false  
  end

  context "published?" do
    before { allow(subject).to receive(:published?).and_return(true) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description)}
    it { is_expected.to validate_presence_of(:location)}
    it { is_expected.to validate_presence_of(:start_date)}
    it { is_expected.to validate_presence_of(:end_date)}
  end
end