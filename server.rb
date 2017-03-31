#!/usr/bin/ruby
require 'sinatra'  
require 'sinatra/namespace'  
require 'mongoid'

configure do  
  Mongoid.load!("mongoid.yml", settings.environment)
  set :server, :puma
  set :bind, "0.0.0.0"
end  

Dir["./models/*.rb"].each { |file| require file }
Dir["./helpers/*.rb"].each { |file| require file }
Dir["./routes/*.rb"].each { |file| require file }

before do
  content_type 'application/json'
end

