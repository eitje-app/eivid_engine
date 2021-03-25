module Eivid::RequestService   
  class << self

    def connect_general
      VimeoMe2::VimeoObject.new(Figaro.env.VIMEO_ACCESS_TOKEN)
    end

    def connect_user
      VimeoMe2::User.new(Figaro.env.VIMEO_ACCESS_TOKEN)
    end

  end
end