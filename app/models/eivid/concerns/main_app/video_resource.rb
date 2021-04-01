module Eivid::Concerns::MainApp::VideoResource
  extend ActiveSupport::Concern
  included do
  
    has_many :eivid_video_resources, class_name: 'Eivid::VideoResource', as: :resource
    has_many :eivid_videos, class_name: 'Eivid::Video', through: :eivid_video_resources, source: :video

    scope :has_video,     -> { joins(:eivid_video_resources).distinct }
    scope :has_not_video, -> { where(id: [ids - has_video.ids]) }
  
  end
end