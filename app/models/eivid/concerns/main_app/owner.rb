module Eivid::Concerns::MainApp::Owner
  extend ActiveSupport::Concern
  included do
  
    has_one  :eivid_owner,  class_name: 'Eivid::Owner', foreign_key: 'external_id'
    has_many :eivid_videos, class_name: 'Eivid::Video', source: :eivid_owner, foreign_key: 'owner_id'

    after_create :create_eivid_owner

    def create_eivid_owner
      Eivid::Owner.create(external_id: self.id)
    end
  
  end
end