class MeetingsController < ApplicationController
  before_action :set_meeting, only: [:show, :destroy]

  def index
    # @meetings = current_user.meetings
    #

    @meetings_current_user = current_user.meetings
    @meetings_lawyer = lawyer_meetings

    @meetings = (@meetings_current_user + @meetings_lawyer).uniq
    @meetings = @meetings.sort { |a, b| [a.availability.date, a.availability.time] <=> [b.availability.date, b.availability.time] }
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

   def destroy

    @meeting = Meeting.find(params[:id])
    # session[:email] = @meeting.availability.user.email
    # @email = @meeting.availability.user.email
    # @availability = @meeting.availability
    @meeting.destroy

    # redirect_to availability_path(@availability)
    @email = scheduled_false
    # redirect_to meetings_path
    redirect_to canceled_path(email: @email)
    # redirect_to root_path(email: @email)
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

      return session[:email] = @meeting.user.email
    else
      @meeting.availability.scheduled = false
      @meeting.availability.save!
      return session[:email] = @meeting.availability.user.email
    end

  end

  def lawyer_meetings
    Meeting.all.select do |meeting|
      meeting.availability.user == current_user

    end
  end
end
