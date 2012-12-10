require 'rubygems'
require 'sinatra'
require 'data_mapper'
require File.dirname(__FILE__) + '/models.rb'
#require 'dm-sqlite-adapter'
require 'dm-postgres-adapter'

enable :sessions

get '/' do
    @community = params[:community]
    
    @result = Responses.first(:url => @community)
    if @result.complete == true
        #"redirecting to " + @community
        redirect @community
    elsif @result.complete == false
        erb :terms
    else
        @result.create(:url => @community, :complete => false)
        @result.save
        #STDERR.puts @result.errors.inspect
        erb :terms
    end
end

get '/continue' do
    @community = params[:community]
    @result = Responses.first(:url => @community)
    @result.complete = true
    @result.save
    #STDERR.puts @result.errors.inspect
    #"redirecting to " + @community
    redirect @community
end

get '/db' do
    @responses = Responses.all
end

get '/exit' do
    @community = params[:community]
    erb :exit
end
