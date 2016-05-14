class GroupEvent < ActiveRecord::Base
  
  validates_presence_of :status
  validates_presence_of :name, if: lambda{ |event|event.published? }
  validates_presence_of :description, if: lambda{ |event|event.published? }
  validates_presence_of :location, if: lambda{ |event|event.published? }
  validates_presence_of :start_date, if: lambda{ |event| event.published? }
  validates_presence_of :end_date, if: lambda { |event| event.published? }
  validate :end_date_after_start_date

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