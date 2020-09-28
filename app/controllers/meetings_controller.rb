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
      flash[:alert] = @failures
      respond_to do |format|
        format.js { render nothing: true, locals: { alert: @failures } }
      end
      return
    else
      redirect_to meetings_path, notice: 'Meetings were successfully created.'
    end
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

  def meeting_params(key)
    params.require(key).permit(:subject, :availability_id)
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
