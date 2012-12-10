require 'data_mapper'
DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3://#{Dir.pwd}/project.db')
class Responses
    include DataMapper::Resource
    property :id,             Serial
    property :url,            Text
    property :complete,       Boolean
    property :created_at,     DateTime
    property :updated_at,     DateTime
end
DataMapper.auto_upgrade!