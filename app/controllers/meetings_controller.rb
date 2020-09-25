class MeetingsController < ApplicationController
  before_action :set_meeting, only: [:show, :destroy]

  def index
  end
  def show

  end
  def new
    @meeting = Meeting.new
  end

  def create
    @meeting = Meeting.new(meeting_params)

    @meeting.user = current_user
    if @meeting.availability.user == @meeting.user
      redirect_to :root, alert: 'This time is yours'
    else
      if @meeting.save
        # redirect_to meeting_path(@meeting), notice: 'meeting was successfully created.'
        # redirect_to controller: 'availabilities', action: 'destroy', id: @meeting.availability
        # redirect_to :controller=> 'availabilities', :action=> 'destroy', :id=> @meeting.availability
        render :show, notice: 'meeting was successfully created.'

      else
        render :new
      end
    end
    # redirect_to :controller=>'availabilities', :action=>'destroy', :id => @meeting.availability
  end

  private

  def set_meeting
    @meeting = Meeting.find(params[:id])
  end

  def meeting_params
    params.require(:meeting).permit(:subject, :availability_id)
  end
end
