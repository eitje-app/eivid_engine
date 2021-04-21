# Eivid

Never stops streaming awesome videos, yay!



## Installation

Add the following to your application's Gemfile and run $bundle:

```ruby

gem 'eivid', git: 'https://github.com/eitje-app/eivid_engine', branch: 'production'

```
Or, for development purposes, add instead:

```ruby
local_eivid_path = "/Users/jurriaanschrofer/Documents/eivid"
if ENV["RAILS_ENV"] == 'development' && Dir.glob(local_eivid_path).any?
  gem 'eivid', path: local_eivid_path
else
  gem 'eivid', git: 'https://github.com/eitje-app/eivid_engine', branch: 'production'
end
```

Add the following file to your app's config/initializers directory:

```ruby

# eivid.rb

Eivid.set_mattr_accessors do |config|
  config.owner_model = "owner"
end

```

In this file, set the {owner_model} to your apps owner of videos, which generates the following methods (in this example config.owner_model is set to "organisation"):

```ruby

# retrieves the owner_id from a record
Eivid::Video.first.organisation_id

# returns the owner record of your application
Eivid::Video.first.organisation 

# scope, which returns all records for your application's organisation
Eivid::Video.of_organisation(id)

# returns the owner record of your application
Eivid::Owner.organisation

```



## Setup

Create and run the required migrations:

```bash

$ rails eivid:install:migrations
$ rails db:migrate

```

For your application's owner model (in this example Organisation), run the following command, which creates all dedicated folders within Vimeo:

```ruby

Organisation.find_each { |owner| Eivid::Owner.create(external_id: owner.id) }

```

Add the following to your routes.rb:

```ruby

mount Eivid::Engine => "/eivid"

```

Set the following environment variables in your application:

```ruby

VIMEO_ACCESS_TOKEN

```



## Include Owner

Witin your application's owner model (in this example Organisation), add to following:

```ruby

eivid_owner

```

Which runs an after_create effect, which creates an Eivid::Owner for every new Organisation record, and generates the following methods within your application:

```ruby

# returns a single Eivid::Owner record for the owner, which includes a Vimeo folder_id
Organisation.first.video_owner

#returns all Eivid::Video records, which each contain an url to the video and vimeo_id
Organisation.first.videos

```



## Include VideoResource

Besides an owner, an Eivid::Video can belongs to many resources of your main application, e.g. a Post, Manual or Message. This functionality is provided through a join table Eivid::VideoResource, which enables any model of your application to has_many Eivid::VideoResource. In order to create this association, paste the following code in your application's resource holder:

```ruby

eivid_video_resource

```

Which generates the following methods within your application (in this example for a Post model):

```ruby

# returns join table records
Post.first.video_resources

# returns video records
Post.first.videos

# scope which returns all records (here Post instances) which have a video
Post.has_video

# scope which returns all records (here Post instances) which do not have a video
Post.has_not_video

```



## Include User

An Eivid::Video can optionally belong to your application's User model. If you want to hook up your User with Eivid::Video, include the following in your user.rb file.

Note: for the user_id to be added to a Eivid::Video record, your main application should provide an User instance @user within your controllers. 

```ruby

eivid_user

```

Which generates the following methods within your application:

```ruby

# returns video records
User.first.videos

# returns join table records
User.first.video_resources

# returns an User instance
Eivid::Video.first.user

```





## Optional Config: Set Controller before_action

Before each controller action, the the @owner variable is set through through ```params['external_owner_id']```. If you want to overwrite this logic, because your main application already has some kind of standardized before hooks, you can do that by setting the following in your config/initializers/eivid.rb file. This code will be evaluated, instead of ```params['external_owner_id']```.

```ruby

Eivid.set_mattr_accessors do |config|
  config.infer_external_owner_id = "@env.organisation.id"
end

```



## Optional Config: Set Front End Notifications

If you want your front end to be notified on the progress of the videos being uploaded to vimeo, you can add the following to your eivid.rb config file. The method fields should be any proc and accept a single positional hash as argument, which stores all the progress information. This proc will be called on any progress change, thus enabbles you to set which method in your main application should handle the change.

```ruby

# eivid.rb

Eivid.set_mattr_accessors do |config|
  config.notify_front_enabled                = true
  config.notify_method_on_upload             = -> (data) { "NotifyFrontOnVimeoService.progress(#{data})" }
  config.notify_method_on_video_available    = -> (data) { "NotifyFrontOnVimeoService.progress(#{data})" }
  config.notify_method_on_versions_available = -> (data) { "NotifyFrontOnVimeoService.progress(#{data})" }
end

```





