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
      @file = File.open(video_path) 

      @request  = HTTParty.post UPLOAD_URL, **upload_video_headers
      @response = JSON.parse(@request).deep_symbolize_keys

      @upload_link = @response.dig(:upload, :upload_link)
      @video_link  = @response.dig(:link)

      tus_upload_to_vimeo
    end

    def tus_upload_to_vimeo
      HTTParty.patch @upload_link, body: @file.read, headers: tus_upload_to_vimeo_headers
    end

    def upload_video_headers
      body = {
        "upload" => {
          "approach" => "tus",
          "size"     => @file.size.to_s,
        }
      }

      headers = {
        "Authorization" => "bearer #{Figaro.env.VIMEO_ACCESS_TOKEN}",
        "Content-Type"  => "application/json",
        "Accept"        => "application/vnd.vimeo.*+json;version=3.4" 
      }

      { body: body.to_json, headers: headers }
    end


    def tus_upload_to_vimeo_headers
      {
        "Tus-Resumable" => "1.0.0",
        "Upload-Offset" => "0",
        "Content-Type"  => "application/offset+octet-stream",
        "Accept"        => "application/vnd.vimeo.*+json;version=3.4"
      }
    end

  end
end