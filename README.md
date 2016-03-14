Rails Grape Jumpstart
=====================

A basic starting point for [Grape APIs](https://github.com/ruby-grape/grape) running on Rails.

## Features

Goodies included besides setting up the inital Grape mounting

#### Logging Middleware

Includes custom middleware to log every request in the following format

```
REQUEST METHOD:		GET
REQUEST PATH:		/api/foo
QUERY STRING:		bar=baz
POST PARAMS:		{ "bar": "baz" }	# if method is POST
```

Also included is the [Shog](https://github.com/phallguy/shog) gem, which provides log coloring and formatting based on regular expressions. In a config file, these logs are set to be bold green

#### Error Reporting Middleware

Another helpful middleware, for Rails especially, is a handler for uncaught api exceptions. Normally, whenever your api has an uncaught error, Rails will take over and serve up a 500 with the standard template it uses based on the environment. This can be problematic because it provides clients expecting JSON no indication of what the error might be and it also, depending on your setup, could not be included in the Grape CORS policy. This can cause clients to give unhelpful -1 status codes for the request.

The standard response the middleware will return for any uncaught exception is as follows

```javascript
{
	"code": "500",
	"message": "Something bad has happened",
	"backtrace": [
		...
	]
}
```

This format is entirely confiugrable as a Hash in `lib/middleware/error_handler.rb`. And it also logs the error, using red bold text from shog as mentioned before, in this format

```
API ERROR:	Something bad has happened
API ERROR:	[stack trace]
			[stack trace]
			...
```

#### Spec Optimizations

By default, Rails will do a lot of work building the Grape API over and over again because of the way `rspec/rails` works with request based tests. In this boilerplate, `rspec/rails` is removed in favor of `Rack::Test`. Specs created in the `spec/api` folder will automatically be set up to be tested atomically by `Rack::Test`. 

This increases the run speed of spec suites greatly.

#### 404 Handling

Handles 404 as well, instead of letting Rails take over with a `RoutingError`. This also avoids some of the problems described above. This can be configured in `app/api/base.rb`

#### API Reloading

Automatically reloads changes to Grape API files in development. Thanks to the [Grape README](https://github.com/ruby-grape/grape#reloading-api-changes-in-development).

#### Swagger API Documentation

Comes bundled with [Swagger](http://swagger.io/) for API documentation through the help of [grape-swagger](https://github.com/ruby-grape/grape-swagger) and [grape-swagger-rails](https://github.com/ruby-grape/grape-swagger-rails). You can configure the documentation title and options in `config/initializers/swagger.rb`

#### Route Printing

Run `rake grape:routes` to print all routes for the application, similar to `rake routes` in plain Rails

#### CORS Configuration

Adds CORS configuration on `/api/` in `config/initializers/cors.rb` using `Rack::CORS`. The default is any origin, any method.

#### API Error Helpers

Gives aliases to Grape's `error!` method, for readability. For example, compare writing this

```ruby
error!({ code: '404.12', message: 'User was not found' }, 404)
```

to writing something a little more quickly understandable

```ruby
not_found! 'User was not found', '404.12'
```

The format for these messages is configurable in 

#### Automatic Model Annotation

Makes use of the [annotate](https://github.com/ctran/annotate_models) gem to give helpful schema annotation comments above your Rails models automatically, whenever `rake db:migrate` is run

```ruby
# == Schema Information
#
# Table name: messages
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  feed_id       :integer
#  feed_sequence :integer
#  message_type  :integer
#  payload       :string
#  options       :hstore
#  sent_at       :datetime
#
# Indexes
#
#  index_messages_on_feed_id  (feed_id)
#  index_messages_on_user_id  (user_id)
#

```

#### Enumeration Support

An autoloaded directory `app/enums` has been included to support enums, specifically [EnumerateIt enums](https://github.com/cassiomarques/enumerate_it): the best gem I have found for Ruby/Rails enums.

I find that enumerations and Grape APIs work very well together, especially for validation and entities.

```ruby
desc 'An enum validation example'
params do
	optional :foo_type, type: Integer, values: Enums::FooType.list
end
```

#### Global Configuration

I find the [global](https://github.com/railsware/global) gem helpful for storing environment specific application configurations

## What you need to do

#### Configure Database

Configure the database by adding a database gem and editing the `config/database.yml` file.

#### Rename Rails module

Rename the Rails application module in `config/application.rb` and `config/routes.rb` from `YourApplication` to something more relevant.

#### Optional Trick

Another trick you might find helpful is to use `--depth=1` when cloning this repo, to ignore most of the history. Then you are free to rename the first commit whatever you want

```
git clone --depth=1 git@github.com:arempe93/grape-rails-boilerplate.git myproject
cd myproject
git commit --amend -m "Initial commit or whatever"
```