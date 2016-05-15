class GroupEventsController < ApplicationController
  before_action :set_event, only: [:edit, :update, :destroy]

  def index
    @group_events = GroupEvent.where(active: true)
  end


  def new
  end

  def create
    calculate_start_end_date if calculate_with_duration?
    @group_event = GroupEvent.new(group_event_params)
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
    calculate_start_end_date if calculate_with_duration?

    if @group_event.update(group_event_params)
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
    @group_event_params ||= params.require(:group_event).permit(:name, :description, :location, :start_date, :end_date, :status)
  end

  def calculate_with_duration?
    (!group_event_params[:start_date].present? || !group_event_params[:end_date].present?) && duration.present?
  end

  def calculate_start_end_date
    if group_event_params[:start_date].present?
      group_event_params[:end_date] = group_event_params[:start_date].to_datetime + duration.to_i.days
    elsif group_event_params[:end_date].present?
      group_event_params[:start_date] = group_event_params[:end_date].to_datetime - duration.to_i.days
    else
      group_event_params[:start_date] = DateTime.now
      group_event_params[:end_date] = group_event_params[:start_date] + duration.to_i.days
    end
  end

  def duration
    params[:group_event][:duration]
  end
end