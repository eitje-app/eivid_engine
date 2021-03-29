module Eivid::RequestService   
  class << self

    # vimeo docs:   https://developer.vimeo.com/api/guides/start
    # wrapper docs: https://github.com/bo-oz/vimeo_me2

    BASE_URL   = "https://api.vimeo.com"
    UPLOAD_URL = "#{BASE_URL}/me/videos"

    def connect_general
      VimeoMe2::VimeoObject.new(Figaro.env.VIMEO_ACCESS_TOKEN)
    end

    def connect_user
      VimeoMe2::User.new(Figaro.env.VIMEO_ACCESS_TOKEN)
    end

    def get_status(vimeo_id:)
      client = connect_general
      client.get "#{BASE_URL}/videos/#{vimeo_id}?fields=uri,upload.status,transcode.status"
    end

    def upload_video(video_path:)
      file = File.open(video_path) 

      body = {
        "upload" => {
          "approach" => "tus",
          "size"     => file.size.to_s,
        }
      }

      headers = {
        "Authorization" => "bearer #{Figaro.env.VIMEO_ACCESS_TOKEN}",
        "Accept"        => "application/vnd.vimeo.*+json;version=3.4" 
      }

      options = { body: body, headers: headers }

      res = HTTParty.post UPLOAD_URL, **options
      binding.pry
    end

  end
end