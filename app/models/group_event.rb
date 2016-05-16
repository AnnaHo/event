class GroupEvent < ActiveRecord::Base
  
  validates_presence_of :status
  validates_presence_of :name, if: lambda{ |event|event.published? }
  validates_presence_of :description, if: lambda{ |event|event.published? }
  validates_presence_of :location, if: lambda{ |event|event.published? }
  validates_presence_of :start_date, if: lambda{ |event| event.published? }
  validates_presence_of :end_date, if: lambda { |event| event.published? }
  validates_presence_of :duration, if: lambda { |event| event.published? }
  validate :end_date_after_start_date
  before_validation :set_start_date
  before_validation :set_end_date
  before_validation :set_duration

  def set_start_date
    self.start_date ||= (end_date && duration) ? (end_date - duration.to_i.days) : start_date
  end

  def set_end_date
    self.end_date ||= (start_date && duration) ? (start_date + duration.to_i.days) : end_date
  end

  def set_duration
    self.duration ||= (start_date && end_date) ? ((end_date - start_date)/(60*60*24)).to_i : duration
  end

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "cannot be before the start date") 
    end 
  end
  
  def draft?
    status == "draft"
  end

  def published?
    status == "published"
  end
end