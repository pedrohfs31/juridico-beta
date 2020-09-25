class MeetingsController < ApplicationController
  before_action :set_meeting, only: [:show, :destroy]

  def index
    # @meetings = current_user.meetings
    #
    @meetings_manager = current_user.meetings
    @meetings_lawyer = lawer_meetings
    @meetings = @meetings_manager + @meetings_lawyer
  end



  def show

  end
  def new
    @meeting = Meeting.new
  end

  def create
    @meeting = Meeting.new(meeting_params)

    @meeting.user = current_user

    if @meeting.save
      # redirect_to meeting_path(@meeting), notice: 'meeting was successfully created.'
      # redirect_to controller: 'availabilities', action: 'destroy', id: @meeting.availability
      # redirect_to :controller=> 'availabilities', :action=> 'destroy', :id=> @meeting.availability
      render :show, notice: 'meeting was successfully created.'

    else
      render :new
    end
    # redirect_to :controller=>'availabilities', :action=>'destroy', :id => @meeting.availability

  end

   def destroy
    @meeting = Meeting.find(params[:id])
    # @availability = @meeting.availability
    @meeting.destroy

    # redirect_to availability_path(@availability)
    scheduled_false
    redirect_to meetings_path
  end

  private

  def set_meeting
    @meeting = Meeting.find(params[:id])
  end

  def meeting_params
    params.require(:meeting).permit(:subject, :availability_id)
  end


  def scheduled_false

    if current_user == @meeting.availability.user
      @meeting.availability.destroy
    else
      @meeting.availability.scheduled = false
      @meeting.availability.save!
    end

  end

  def lawer_meetings
    Meeting.all.select do |meeting|
      meeting.availability.user = current_user
    end
  end
end
