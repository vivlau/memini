class SchedulesController < ApplicationController
  def index
  end

  def new
    @schedule = Schedule.new
  end

  def create
    schedule = Schedule.new schedule_params
    schedule.save
    render json: params
  end

  def show
  end

  def make_google_calendar_reservations
    @schedule = @cohort.schedules.find_by(slug:
      params[:slug])
    @calendar = GoogleCalWrapper.new(current_user)
    @calendar.book_rooms(@schedule)
  end

  private

  def schedule_params
    params.require(:schedule).permit(:location, :departure_date, :return_date, :traveller_type)
  end
end
