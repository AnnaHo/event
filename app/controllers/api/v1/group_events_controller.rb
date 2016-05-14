class Api::V1::GroupEventsController < ApiController
  
  def index
    render json: GroupEvent.all
  end

end