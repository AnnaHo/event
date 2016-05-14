class Api::V1::GroupEventsController < ApiController
  
  def index
    render json: GroupEvent.all
  end

  def create
    group_event = GroupEvent.new(group_event_params)

    if group_event.save
      render json: group_event
    else
      render json: {message: "failed to create event", errors: group_event.errors.full_messages}, status: 422
    end
  end

  private

  def group_event_params
    params.require(:group_event).permit(:name, :description, :location, :start_date, :end_date, :duration, :status)
  end
end