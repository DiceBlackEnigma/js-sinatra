require 'data_mapper'

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

configure :production do
  DataMapper.setup(:default, 'postgres://daisi:12345@herokuapp.com/database')
end

class Song
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :lyrics, Text
  property :length, Integer
  property :released_on, Date

  def released_on=(date)
    super Date.strptime(date, '%m/%d/%Y')
  end
end

DataMapper.finalize
