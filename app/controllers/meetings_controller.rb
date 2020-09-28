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
    render partial: "meetings/new", locals: { availability_id: params[:availability_id] }
  end

  def create
    # if @meeting.availability.user == @meeting.user
    #   render alert: 'This is your own avaliability, choose another.'
    # else
    # end
    @failures = {}
    @meeting_keys = params.keys.select { |k| k.match(/meeting\w+/) }
    @meeting_keys.each_with_index do |key, i|
      begin
        meeting = Meeting.new(meeting_params(key))
        meeting.user = current_user
        meeting.save!
      rescue ActiveRecord::RecordInvalid => invalid
        @failures[i] = "Meeting (#{meeting.availability.date.strftime("%A, %d %b %Y")}, at #{meeting.availability.time.strftime('%k:%M')}) was not sheduled because: #{invalid.message}."
      end
    end
    if @failures.size > 0
      flash[:save_errors] = @failures
      respond_to do |format|
        format.js { render nothing: true }
      end
      return
    else
      redirect_to meetings_path, notice: 'Your meetings were successfully created.'
    end
  end

  def single_meeting
    @meeting = Meeting.new
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

  def meeting_params(key)
    params.require(key).permit(:subject, :availability_id)
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
