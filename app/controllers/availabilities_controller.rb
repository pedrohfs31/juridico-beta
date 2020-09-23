class AvailabilitiesController < ApplicationController
  before_action :set_availability, only: [:show, :destroy]

  def index
    @availabilities = Availability.all
  end

  def show

  end

  def new

    @times = { 8.1 => "08:00", 8.2 => "08:20", 8.3 => "08:40", 9.1 => "09:00", 9.2 => "09:20", 9.3 => "09:40", 10.1 => "10:00", 10.2 => "10:20", 10.3 => "10:40", 11.1 => "11:00", 11.2 => "11:20", 11.3 => "11:40", 12.1 => "12:00", 12.2 => "12:20", 12.3 => "12:40", 13.1 => "13:00", 13.2 => "13:20", 13.3 => "13:40", 14.1 => "14:00", 14.2 => "14:20", 14.3 => "14:40", 15.1 => "15:00", 15.2 => "15:20", 15.3 => "15:40", 16.1 => "16:00", 16.2 => "16:20", 16.3 => "16:40", 17.1 => "17:00", 17.2 => "17:20", 17.3 => "17:40", }
    @availability = Availability.new

    # @times =
  end

  def create

    @availability = Availability.new(availability_params)

    @availability.user = current_user

    if @availability.save
      redirect_to @availability, notice: 'availability was successfully created.'
    else
      render :new
    end
  end

  def destroy

    if @availability.user != current_user
      redirect_to root_path, alert: 'Not authorized'
      return
    end

    @availability.destroy
    redirect_to availabilities_path
  end


  private

  def set_availability
    @availability = Availability.find(params[:id])
  end

  def availability_params
    params.require(:availability).permit(:date, :time)
  end

end
