module Eivid::Concerns::MainApp::VideoConcerns
  extend ActiveSupport::Concern
  included do
  
    scope :has_video,             -> { joins(:videos).distinct }
    scope :has_not_video,         -> { joins(:videos).where('eivid_videos.id' => nil) }

    scope :has_pending_video,     -> { joins(:videos).where('eivid_videos.uploaded' => false) }
    scope :has_not_pending_video, -> { where(id: [ids - has_pending_video.ids]) }
    
    # caution: due to the has_many with .distinct, the condition only has to be satisfied once
    scope :has_processed_video,   -> { joins(:videos).where('eivid_videos.uploaded': true).distinct }
    scope :has_unprocessed_video, -> { joins(:videos).where('eivid_videos.uploaded' => false).distinct }

  end
end