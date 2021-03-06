class EventsController < ApplicationController
  def index
    @schedule = Schedule.find(params[:schedule_id])
    @events = Event.where(schedule_id: @schedule.id)
  end

  def create
    @schedule = Schedule.find(params[:id])
    @event = Event.new(event_params)
    @event.schedule = @schedule

    if @event.save
      redirect_to schedule_path(@schedule), notice: 'Event Created!'
    else
      render '/schedules/show'
    end
  end

  def show
    @schedule = Schedule.find(params[:schedule_id])
    @events = Event.where(schedule_id: @schedule.id)
  end

  private

  def event_params
    params.require(:event).permit(:event_name, :start_date, :start_time, :end_date, :end_time, :event_location, :event_description, :categories, :search_term, :name, :images, :rating, :reviews, :coordinates, :address, :phone, :price, :hours)
  end
end
