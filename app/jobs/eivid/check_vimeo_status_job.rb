module Eivid
  class CheckVimeoStatusJob < ApplicationJob

    def perform(video_record:)
      log_perform
      @video_record = video_record
      set_vimeo_id
      set_video_status
      
      upload_completed ? process_completed : rerun_job
    end

    private

    def set_vimeo_id
      @vimeo_id ||= @video_record.url.split('/').last
    end

    def set_video_status
      @video_status = Eivid::RequestService.get_status(vimeo_id: @vimeo_id)["upload"]["status"]
    end

    def upload_completed
      @video_status == "complete"
    end

    def process_completed
      @video_record.update(uploaded: true)
      notify_front
    end

    def notify_front
      #
    end

    def rerun_job
      CheckVimeoStatusJob.set(wait: 10.seconds).perform_later(video_record: @video_record)
    end

    def log_perform
      logger = Logger.new "log/test_polling_job_#{Time.now.strftime("%T")}.log"
      logger.debug "yay, CheckVimeoStatusJob ran!"
    end

  end
end
