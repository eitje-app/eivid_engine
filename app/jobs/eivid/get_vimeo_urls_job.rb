module Eivid
  class GetVimeoUrlsJob < ApplicationJob

    include Eivid::GetVimeoUrlsMixin

    retry_on(VideoUrlsUnavailableError, wait: 10.seconds, attempts: 50) do |job, error| 
      raise Eivid::VideoUrlsAllAttemptsFailedError, "failed after the set max attempts (#{job.executions} times)"
    end

    discard_on ActiveJob::DeserializationError

    def perform(video_record:, vimeo_id:)
      @video_record = video_record
      @vimeo_id     = vimeo_id

      set_response
      set_url_sd
      set_url_hd
      set_url_thumbnail
      
      validate_url_presence
      validate_url_thumbnail

      update_record
      schedule_hd_url_job
      notify_front
    end

    private

    def notify_front
      data = { video: @video_record.slice(:id, :user_id), progress: { percentage: 100, step: "All video versions are available on Vimeo." } }
      NotifyFrontService.progress('notify_method_on_versions_available', data)
    end

    def update_record
      @video_record.update(uploaded: true, url_sd: @url_sd, url_hd: @url_hd, url_thumbnail: @url_thumbnail)
    end

    def schedule_hd_url_job
      Eivid::GetVimeoHdUrlJob.set(wait: 5.seconds).perform_later(video_record: @video_record, vimeo_id: @vimeo_id)
    end

  end
end
