module Eivid::Concerns::RequestService::DeleteVideo
  extend ActiveSupport::Concern

  def destroy(video:)
    @video = video
    delete_from_vimeo
    video.destroy
  end

  private

  def delete_from_vimeo
    return unless @video.uploaded
    HTTParty.delete "#{Eivid::RequestService::VIDEOS_URL}/#{@video.vimeo_id}", headers: default_headers
  end
  
end