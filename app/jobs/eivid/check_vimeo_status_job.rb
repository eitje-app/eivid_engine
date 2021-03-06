module Eivid
  class CheckVimeoStatusJob < ApplicationJob

    retry_on(VideoUnavailableError, wait: 10.seconds, attempts: 50) do |job, error|
      raise Eivid::VideoUnavailableAllAttemptsFailedError, "failed after the set max attempts (#{job.executions} times)"
    end

    discard_on ActiveJob::DeserializationError

    after_perform :poll_vimeo_urls

    def perform(video_record:)
      @video_record = video_record

      set_vimeo_id
      set_video_status
      
      upload_completed ? notify_front : (raise Eivid::VideoUnavailableError)
    end

    private

    def set_vimeo_id
      @vimeo_id ||= @video_record.url_embedded.split('/').last
    end

    def set_video_status
      @video_status = Eivid::RequestService.get_status(vimeo_id: @vimeo_id)["status"]
    end

    def upload_completed
      @video_status == "available"
    end

    def notify_front
      data = { video: @video_record.slice(:id, :user_id), progress: { percentage: 66, step: "The video is available on Vimeo." } }
      NotifyFrontService.progress('notify_method_on_video_available', data)
    end

    def report_max_poll
      raise MaximumVimeoPollReachedError.new (
        "the maximum amount of polling Vimeo (#{@@maximum_vimeo_polls} times) for the status of Eivid::Video ##{@video_record&.id} is reached."
      )
    end

    def poll_vimeo_urls
      GetVimeoUrlsJob.perform_later(video_record: @video_record, vimeo_id: @vimeo_id)
    end

  end
end
