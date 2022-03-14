module Eivid::Concerns::RequestService::UploadVideo
  extend ActiveSupport::Concern

  def upload_video(video_path:)
    @file = File.open(video_path)
    retrieve_upload_link
    tus_upload_to_vimeo
    @response
  end

  private

  def retrieve_upload_link
    efforts     = 0
    max_efforts = 180
    sleep_time  = 1

    while @upload_link.blank? && efforts < max_efforts do

      puts "Trying to retrieve upload link from Vimeo... try #{efforts}/#{max_efforts} with #{sleep_time} seconds sleep in between..."

      @request     = HTTParty.post Eivid::RequestService::VIDEOS_URL, **upload_params
      @response    = JSON.parse(@request).deep_symbolize_keys
      @upload_link = @response.dig(:upload, :upload_link)

      if @upload_link.blank?
        sleep sleep_time
        efforts += 1

      else
        puts "successfully retrieved the Vimeo upload link!"
      end
    end
  end

  def tus_upload_to_vimeo
    efforts     = 0
    max_efforts = 10
    sleep_time  = 30
    successful  = false

    while !successful && efforts < max_efforts

      puts "Trying to upload the video to Vimeo... try #{efforts}/#{max_efforts} with #{sleep_time} seconds sleep in between..."
      response = HTTParty.patch @upload_link, body: @file.read, headers: tus_headers

      if response.code >= 500
        sleep sleep_time
        efforts += 1
      else
        successful = true
        puts "successfully uploaded the video to Vimeo!"
      end
    end
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
