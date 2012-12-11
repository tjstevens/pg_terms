#require 'rubygems'
require 'sinatra'

#enable :sessions

get '/' do
    # Grab community URL from inbound request so we can pass it to the view
    @community = params[:community]

    # See if there is a covergirl cookie in the browser
    @cookie = request.cookies["covergirl"]

    # If we find one, we know they previously accepted the T&Cs so send them along otherwise send them to the T&Cs page
    if @cookie == @community
        redirect @community
    else
		erb :terms
    end
end

get '/continue' do
	# This page is for users returning from ACCEPTING the T&Cs
	# Like always, grab the community URL from the inbound request so we can pass them along when we are done
    @community = params[:community]

    # Setup the expiration variable that will go into the cookie... we're shooting for about a month
    @expiration = Time.now + (60 * 60 * 24 * 30)

    # Stamp the cookie with the community URL and expiration date
	response.set_cookie("covergirl", :value => @community, :expires => @expiration)

	# ... and off you go!
	redirect @community
end

get '/exit' do
	# This pace is for users returning from DECLINING the T&Cs
	# Again, grab the community URL from the inbound request so we can pass it to the view... just in case they change their mind
    @community = params[:community]

    # ... and you are outta here!
    erb :exit
end
