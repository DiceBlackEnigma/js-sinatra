require 'sinatra'
require 'sinatra/reloader' if development?
require './song'

configure do
  enable :sessions
  set :username, 'frank'
  set :password, 'sinatra'
end

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end

get '/login' do
  haml :login
end

post '/login' do
  if params[:username] == settings.username && params[:password] == settings.password
    session[:admin] = true
    redirect to('/songs')
  else
    haml :login
  end
end

get '/logout' do
  session.clear
  redirect to('/login')
end

get '/styles.css' do
  scss :styles
end

get '/' do
  haml :index
end

get '/about' do
  haml :about
end

get '/contact' do
  haml :contact
end

get '/songs' do
  @songs = Song.all
  haml :'songs/index'
end

get '/songs/new' do
  halt(401, 'Not Authorized') unless session[:admin]
  @song = Song.new
  haml :'songs/new'
end

get '/songs/:id' do
  @song = Song.get(params[:id])
  haml :'songs/show'
end

post '/songs' do
  song = Song.create(params[:song])
  redirect to("/songs/#{song.id}")
end

get '/songs/:id/edit' do
  @song = Song.get(params[:id])
  haml :'songs/edit'
end

put '/songs/id' do
  song = Song.get(params[:id])
  song.update(params[:somg])
  redirect to("/songs/#{song.id}")
end

delete '/songs/:id' do
  Song.get(params[:id]).destroy
  redirect to('/songs')
end

not_found do
  haml :not_found
end
