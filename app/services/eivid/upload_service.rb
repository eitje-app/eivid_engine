module Eivid::UploadService   
  class << self

    def upload(owner:, video_file:)
      @video_file           = video_file
      @video_record         = Eivid::Video.create(owner_id: owner.id)
      @file_name, @file_ext = @video_file.original_filename.split('.') 
      
      create_temp_file
      upload_to_vimeo
      @video_record
    end

    private

    def create_temp_file
      @temp_file = Tempfile.new([@file_name, ".#{@file_ext.downcase}"], "#{Rails.root}/tmp/")
      @temp_file << @video_file.tempfile.open.read
      
      @temp_path = @temp_file.path
      @temp_file.close
    end

    def upload_to_vimeo
      Eivid::UploadVimeoJob.perform_later(video_record: @video_record, video_path: @temp_path)
    end

  end
end