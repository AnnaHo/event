class GroupEvent < ActiveRecord::Base
  
  validates_presence_of :status
  validates_presence_of :name, if: lambda{ |event|event.published? }
  validates_presence_of :description, if: lambda{ |event|event.published? }
  validates_presence_of :location, if: lambda{ |event|event.published? }
  validates_presence_of :start_date, if: lambda{ |event| event.published? }
  validates_presence_of :end_date, if: lambda { |event| event.published? }
  validates_presence_of :duration, if: lambda { |event| event.published? }
  validate :end_date_after_start_date
  

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "cannot be before the start date") 
    end 
  end

  def calculate_event_date
    if calculate_by_duration?
      calculate_start_end_date_by_duration
    else
      calculate_duration_days
    end
  end

  def calculate_duration_days
    if start_date && end_date && (end_date > start_date)
      self.duration = ((end_date - start_date)/(60*60*24)).to_i
    end   
  end

  def calculate_start_end_date_by_duration
    if start_date.nil? ^ end_date.nil?
      if start_date
        self.end_date = start_date + duration.to_i.days
      else
        self.start_date = end_date - duration.to_i.days
      end
    else
      self.start_date = DateTime.now
      self.end_date = self.start_date + duration.to_i.days
    end
  end

  def calculate_by_duration?
    duration && !(start_date && end_date)
  end
  
  def draft?
    status == "draft"
  end

  def published?
    status == "published"
  end
end