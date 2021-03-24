# Eivid

Never stops streaming awesome videos, yay!

## Installation

Add this line to your application's Gemfile:

```ruby

gem 'eivid', git: 'https://github.com/eitje-app/eivid_engine', branch: 'production'

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

```
