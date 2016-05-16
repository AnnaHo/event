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
  
  describe '#calculate_by_duration?' do
    context 'with duration exists' do
      it 'return true if start_date/end_date are either exists' do
        group_event = GroupEvent.new(name: "an event", status: "draft", start_date: DateTime.now, end_date: "", duration: 4)
        expect(group_event.calculate_by_duration?).to be true
      end

      it 'return false if start_date/end_date are not exists' do
        group_event = GroupEvent.new(name: "an event", status: "draft", start_date: DateTime.now, end_date: DateTime.now+4.days, duration: 4)
        expect(group_event.calculate_by_duration?).to be false
      end
    end
  end

    
  describe 'calculate_duration_days' do
    it 'assign end date if duration and start_date exists' do
      start_date = DateTime.now
      group_event = GroupEvent.new(name: "an event", status: "draft", start_date: start_date, end_date: "", duration: 4)
      group_event.calculate_start_end_date_by_duration  
      expect(group_event.end_date).to eq(start_date + group_event.duration.days)
    end

    it 'assign start date if duration and end_date exists' do
      end_date = DateTime.now
      group_event = GroupEvent.new(name: "an event", status: "draft", start_date: "", end_date: end_date, duration: 4)
      group_event.calculate_start_end_date_by_duration  
      expect(group_event.start_date).to eq(end_date - group_event.duration.days)
    end

    it 'assign start_date/end_date if only duration exists' do
      group_event = GroupEvent.new(name: "an event", status: "draft", start_date: "", end_date: "", duration: 4)
      group_event.calculate_start_end_date_by_duration  
      expect(group_event.start_date).not_to be nil
      expect(group_event.end_date).not_to be nil
    end
  end

  describe 'calculate_start_end_date_by_duration' do
    it 'assign duration days if start_date and end_date both exists and valid' do
      start_date = DateTime.now
      end_date = DateTime.now + 4.days
      group_event = GroupEvent.new(name: "an event", status: "draft", start_date: start_date, end_date: end_date, duration: 4)
      expect(group_event.duration).to eq 4
    end
  end
end
