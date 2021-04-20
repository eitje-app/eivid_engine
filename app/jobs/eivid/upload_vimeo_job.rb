module Eivid
  class UploadVimeoJob < ApplicationJob

    def perform(video_record:, video_path:)
      @video_record = video_record
      @video_path   = video_path
      @video_file   = File.open(video_path).read

      upload_to_vimeo
      set_attributes
      update_record
      add_to_folder
      
      notify_front
      check_status
    end

    private

    def upload_to_vimeo      
      @response = Eivid::RequestService.upload_video(video_path: @video_path)
    end

    def set_attributes
      set_vimeo_url
      set_vimeo_id
    end

    def set_vimeo_url
      @vimeo_url = @response.dig(:link)
    end

    def set_vimeo_id
      @vimeo_id = @vimeo_url.split('/').last
    end

    def update_record
      @video_record.update(url_embedded: @vimeo_url, vimeo_id: @vimeo_id)
    end

    def add_to_folder
      Eivid::RequestService.add_video_to_folder(video_record: @video_record)
    end

    def check_status
      CheckVimeoStatusJob.perform_later(video_record: @video_record)
    end

    def notify_front
      data = { video: @video_record.slice(:id, :user_id), progress: { percentage: 33, step: "The video has been uploaded to Vimeo." } }
      NotifyFrontService.progress('notify_method_on_upload', data)
    end

  end
end
