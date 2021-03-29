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

      options = { body: body.to_json, headers: headers }

      @request  = HTTParty.post UPLOAD_URL, **options
      @response = JSON.parse(@request).deep_symbolize_keys

      @upload_link = @response.dig(:upload, :upload_link)
      @video_link  = @response.dig(:link)
      @video_uri   = "#{BASE_URL}/#{@response.dig(:uri)}"
      @approach    = @response.dig(:upload, :approach)

      # binding.pry
      upload_to_vimeo
    end

    def upload_to_vimeo
      headers = {
        "Tus-Resumable" => "1.0.0",
        "Upload-Offset" => "0",
        "Content-Type"  => "application/offset+octet-stream",
        "Accept"        => "application/vnd.vimeo.*+json;version=3.4"
      }

      # res = HTTParty.patch @upload_link, body: @file.read, headers: headers
      binding.pry
    end

  end
end