module Eivid::RequestService   
  
  VIMEO_ID          = "136419353"
  BASE_URL          = "https://api.vimeo.com"
  UPLOAD_URL        = "#{BASE_URL}/me/videos"
  FOLDER_URL        = "#{BASE_URL}/me/projects"
  ADD_TO_FOLDER_URL = -> (folder_id, video_id) { "#{FOLDER_URL}/#{folder_id}/videos/#{video_id}" }


  class << self

    # vimeo docs:   https://developer.vimeo.com/api/guides/start
    # wrapper docs: https://github.com/bo-oz/vimeo_me2

    include Eivid::Concerns::RequestService::ManageFolder
    include Eivid::Concerns::RequestService::PollStatus
    include Eivid::Concerns::RequestService::UploadVideo

    def connect_general
      VimeoMe2::VimeoObject.new(Figaro.env.VIMEO_ACCESS_TOKEN)
    end

    def connect_user
      VimeoMe2::User.new(Figaro.env.VIMEO_ACCESS_TOKEN)
    end

  end
end