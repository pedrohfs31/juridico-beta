class AvailabilitiesController < ApplicationController
  before_action :set_availability, only: [:show, :destroy]

  def index
    @availabilities = Availability.where(scheduled: false).order(date: :asc, time: :asc)
  end

  def show

  end

  def new
    @times = {}
    (8..17).to_a.each do |hour|
      (1..3).to_a.each do |period|
        case period
        when 1
         @times["#{hour}.#{period}".to_f] = "#{sprintf("%02d", hour)}:00"
        when 2
          @times["#{hour}.#{period}".to_f] = "#{sprintf("%02d", hour)}:20"
        else
          @times["#{hour}.#{period}".to_f] = "#{sprintf("%02d", hour)}:40"
        end
      end
    end
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
