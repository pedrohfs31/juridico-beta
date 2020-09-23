class AvailabilitiesController < ApplicationController
  def index
    @availabilities = Availability.all
  end


  def new
    @availability = Availability.new

    # @times =
  end

  def create

    @availability = Availability.new(availability_param)

    @availability.user = current_user
  end


  private

  def availability_params
    params.require(:availability).permit(:date, :time)
  end

end
