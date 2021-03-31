# vimeo docs:   https://developer.vimeo.com/api/guides/start
# wrapper docs: https://github.com/bo-oz/vimeo_me2

module Eivid::RequestService   
  
  VIMEO_ID          = "136419353"
  BASE_URL          = "https://api.vimeo.com"
  VIDEOS_URL        = "#{BASE_URL}/me/videos"
  FOLDER_URL        = "#{BASE_URL}/me/projects"
  ADD_TO_FOLDER_URL = -> (folder_id, video_id) { "#{FOLDER_URL}/#{folder_id}/videos/#{video_id}" }

  class << self

    include Eivid::Concerns::RequestService::ManageFolder
    include Eivid::Concerns::RequestService::PollStatus
    include Eivid::Concerns::RequestService::UploadVideo
    include Eivid::Concerns::RequestService::DeleteVideo
    include Eivid::Concerns::RequestService::TestingMethods

    private

    def default_headers
      {
        "Authorization" => "bearer #{Figaro.env.VIMEO_ACCESS_TOKEN}",
        "Content-Type"  => "application/json",
        "Accept"        => "application/vnd.vimeo.*+json;version=3.4" 
      }    
    end

    def tus_headers
      {
        "Tus-Resumable" => "1.0.0",
        "Upload-Offset" => "0",
        "Content-Type"  => "application/offset+octet-stream",
        "Accept"        => "application/vnd.vimeo.*+json;version=3.4"   
      }
    end

  end
end