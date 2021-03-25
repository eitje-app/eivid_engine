# Eivid

Never stops streaming awesome videos, yay!

## Installation

Add the following lines to your application's Gemfile:

```ruby

gem 'eivid', git: 'https://github.com/eitje-app/eivid_engine', branch: 'production'
gem 'vimeo_me2', git: "https://github.com/bo-oz/vimeo_me2.git"

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

# returns the owner record of your application, through a belongs_to association
Eivid::Video.first.organisation 

# scope, which returns all records for your application's organisation
Eivid::Video.of_organisation(id)

```

Create and run the required migrations:

```bash

$ rails eivid:install:migrations
$ rails db:migrate

```
Add the following to your routes.rb:
```ruby

mount Eivid::Engine => "/eivid"

```
Set the following environment variables in your application:
```ruby

VIMEO_ACCESS_TOKEN

```
