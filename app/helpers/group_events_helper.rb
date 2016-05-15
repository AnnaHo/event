module GroupEventsHelper

  def duration event
    ((event.end_date - event.start_date)/(60*60*24)).to_i if event.start_date && event.end_date
  end
  
end