module Eivid
  class UploadVimeoJob < ApplicationJob

    def perform(video_record:, video_path:)
      @video_record = video_record
      @video_path   = video_path
      @video_file   = File.open(video_path).read

      upload_to_vimeo
      @vimeo_url = @response.dig(:link)
      @vimeo_id  = @vimeo_url.split('/').last

      update_record
      add_to_folder
      check_status
    end

    private

    def upload_to_vimeo      
      @response = Eivid::RequestService.upload_video(video_path: @video_path)
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

  end
end
