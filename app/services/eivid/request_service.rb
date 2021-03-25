module Eivid::RequestService   
  class << self

    # vimeo docs:   https://developer.vimeo.com/api/guides/start
    # wrapper docs: https://github.com/bo-oz/vimeo_me2

    def connect_general
      VimeoMe2::VimeoObject.new(Figaro.env.VIMEO_ACCESS_TOKEN)
    end

    def connect_user
      VimeoMe2::User.new(Figaro.env.VIMEO_ACCESS_TOKEN)
    end

    def get_status(vimeo_id:)
      client = connect_general
      client.get "https://api.vimeo.com/videos/#{vimeo_id}?fields=uri,upload.status,transcode.status"
    end

  end
end