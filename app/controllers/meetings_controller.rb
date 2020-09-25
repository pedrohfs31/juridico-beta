class MeetingsController < ApplicationController
  before_action :set_meeting, only: [:show, :destroy]

  def index
  end

  def show
  end

  def new
    render partial: "meetings/new", locals: { availability_id: params[:availability_id] }
  end

  def create
    @successes = 0
    @failures = {}
    @meeting_keys = params.keys.select { |k| k.match(/meeting\w+/) }
    @meeting_keys.each_with_index do |key, i|
      begin
        meeting = Meeting.new(meeting_params(key))
        meeting.user = current_user
        meeting.save ? @successes += 1 : @failures[i + 1] = [key]
      rescue ActiveRecord::RecordInvalid => invalid
        @failures[i + 1] << invalid.record.errors
      end
    end

    if @successes == @meeting_keys.size
      # redirect_to meeting_path(@meeting), notice: 'meeting was successfully created.'
      # redirect_to controller: 'availabilities', action: 'destroy', id: @meeting.availability
      # redirect_to :controller=> 'availabilities', :action=> 'destroy', :id=> @meeting.availability
      render :index, notice: 'Meetings were successfully created.'
    else
      @failures.keys.each do |key|
        render notice: "Meeting ##{key} failed do to #{@failures[key][1]}."
      end
    end

  end

  private

  def set_meeting
    @meeting = Meeting.find(params[:id])
  end

  def meeting_params(key)
    params.require(key).permit(:subject, :availability_id)
  end
end
