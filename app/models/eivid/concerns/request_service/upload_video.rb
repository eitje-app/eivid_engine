module Eivid::Concerns::RequestService::UploadVideo
  extend ActiveSupport::Concern

  def upload_video(video_path:)
    @file        = File.open(video_path) 
    @request     = HTTParty.post Eivid::RequestService::VIDEOS_URL, **upload_params
    @response    = JSON.parse(@request).deep_symbolize_keys
    @upload_link = @response.dig(:upload, :upload_link)

    tus_upload_to_vimeo
    @response
  end

  private

  def tus_upload_to_vimeo
    HTTParty.patch @upload_link, body: @file.read, headers: tus_headers
  end

  def upload_params
    body = {
      "upload" => {
        "approach" => "tus",
        "size"     => @file.size.to_s,
      }
    }

    { body: body.to_json, headers: default_headers }
  end

end