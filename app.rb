require 'rubygems'
require 'sinatra'

enable :sessions

get '/' do
    @community = params[:community]
    erb :terms
    #, :locals => {:community => params[:community]}
end

#post '/form' do
#    redirect "https://covergirl-demo.force.com/"
#                #+ #{params[:message] + '/login')
#end