module Eivid
  class VideoResource < ApplicationRecord

    belongs_to :video
    belongs_to :resource, polymorphic: true, touch: true

  end
end
