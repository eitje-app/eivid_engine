module Eivid::Concerns::MainApp::VideoResource
  extend ActiveSupport::Concern
  included do
  
    has_many :video_resources, class_name: 'Eivid::VideoResource', as: :resource
    has_many :videos, class_name: 'Eivid::Video', through: :video_resources, source: :video

    include Eivid::Concerns::MainApp::VideoConcerns
    
  end
end