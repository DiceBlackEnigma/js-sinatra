require 'sinatra'
require 'sinatra/reloader' if development?

get '/hello' do
  'Hello Sinatra!'
end
