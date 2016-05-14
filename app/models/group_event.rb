class GroupEvent < ActiveRecord::Base
  
  validates_presence_of :name, if: lambda{ |event|event.published? }
  validates_presence_of :description, if: lambda{ |event|event.published? }
  validates_presence_of :location, if: lambda{ |event|event.published? }
  validates_presence_of :start_date, if: lambda{ |event| event.published? }
  validates_presence_of :end_date, if: lambda { |event| event.published? }

  def draft?
    status == "draft"
  end

  def published?
    status == "published"
  end
end