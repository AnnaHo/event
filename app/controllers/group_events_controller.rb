class GroupEventsController < ApplicationController
  before_action :set_event, only: [:edit, :update, :destroy]

  def index
    @group_events = GroupEvent.where(active: true)
  end


  def new
  end

  def create
    @group_event = GroupEvent.new(group_event_params)
    @group_event.calculate_event_date

    if @group_event.save
      redirect_to group_events_path
    else
      flash[:danger] = @group_event.errors.full_messages
      render :new
    end
  end

  def edit
  end

  def update
    @group_event.assign_attributes(group_event_params)
    @group_event.calculate_event_date

    if @group_event.save
      redirect_to group_events_path
    else
      flash[:danger] = @group_event.errors.full_messages
      render :edit
    end 
  end

  def destroy
    if @group_event
      @group_event.active = false
      @group_event.save
      redirect_to group_events_path
    else
      flash[:danger] = "Event can't be removed"
      render :index
    end
  end

  private

  def set_event
    @group_event = GroupEvent.find_by(id: params[:id])
  end

  def group_event_params
    @group_event_params ||= params.require(:group_event).permit(:name, :description, :location, :start_date, :end_date, :duration, :status)
  end
end