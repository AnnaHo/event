class Api::V1::GroupEventsController < ApiController
  before_action :set_event, only: [:update, :destroy]
    
  def index
    render json: GroupEvent.where(active: true)
  end

  def create
    @group_event = GroupEvent.new(group_event_params)
    if @group_event.save
      render json: @group_event
    else
      render json: {message: "failed to create event", errors: @group_event.errors.full_messages}, status: 422
    end
  end

  def update
    if @group_event.update(group_event_params)
      render json: @group_event
    else
      render json: {message: "failed to update event with invalid params", errors: @group_event.errors.full_messages}, status: 422
    end                                                                               
  end
  
  def destroy
    if @group_event
      @group_event.active = false
      @group_event.save
      render json: {message: "group event are removed"}
    else
      render json: {message: "group event not found"}, status: 404
    end
  end

  private

  def set_event
    @group_event = GroupEvent.find_by(id: params[:id])
  end

  def group_event_params
    @group_event_params ||= params.require(:group_event).permit(:name, :description, :location, :start_date, :end_date, :duration,:status)
  end
end