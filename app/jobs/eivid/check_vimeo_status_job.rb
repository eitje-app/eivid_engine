module Eivid
  class CheckVimeoStatusJob < ApplicationJob

    @@maximum_vimeo_polls = 0

    def perform(video_record:)
      log_perform
      @video_record = video_record

      set_status_poll_cnt
      return report_max_poll unless polling_cnt_valid

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
      # implement
    end

    def rerun_job
      CheckVimeoStatusJob.perform_now(video_record: @video_record)
    end

    def log_perform
      # logger = Logger.new "log/test_polling_job_#{Time.now.strftime("%T")}.log"
      # logger.debug "yay, CheckVimeoStatusJob ran!"
    end

    def set_status_poll_cnt
      @status_poll_cnt = @video_record.status_poll_cnt
    end

    def polling_cnt_valid
      @status_poll_cnt < @@maximum_vimeo_polls ? @video_record.update(status_poll_cnt: @status_poll_cnt + 1) : false
    end

    def report_max_poll
      raise MaximumVimeoPollReachedError.new (
        "the maximum amount of polling Vimeo (#{@@maximum_vimeo_polls} times) for the status of Eivid::Video ##{@video_record&.id} is reached."
      )
    end

  end
end
