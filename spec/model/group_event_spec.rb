require 'rails_helper'

describe GroupEvent, :type => :model do
  
  describe 'validations' do
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
      it { is_expected.to validate_presence_of(:duration)}
    end
  end
      
  it 'set_start_date' do
    end_date = DateTime.now
    duration = 4
    group_event = GroupEvent.new(name: "an event", status: "draft", start_date: "", end_date: end_date, duration: duration)
    group_event.save
    expect(group_event.start_date).to eq (end_date - duration.to_i.days)
  end

  it 'set_end_date' do
    start_date = DateTime.now
    duration = 4
    group_event = GroupEvent.new(name: "an event", status: "draft", start_date: start_date, end_date: "", duration: duration)
    group_event.save
    expect(group_event.end_date).to eq (start_date + duration.to_i.days)
  end

  it 'set_duration_date' do
    start_date = DateTime.now
    end_date = start_date + 4.days
    group_event = GroupEvent.new(name: "an event", status: "draft", start_date: start_date, end_date: end_date, duration: "")
    group_event.save
    expect(group_event.duration).to eq 4
  end
end
