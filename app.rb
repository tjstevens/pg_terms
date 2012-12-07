require 'rubygems'
require 'sinatra'

enable :sessions

get '/' do
    @community = params[:community]
    erb :terms
end

get '/exit' do
    @community = params[:community]
    erb :exit
end
