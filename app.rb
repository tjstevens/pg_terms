#require 'rubygems'
require 'sinatra'
require 'erb'
require 'uri'
require 'cgi'

include ERB::Util

#enable :sessions
currentVersion = "2"

get '/' do
    # Grab community URL from inbound request so we can pass it to the view
    @community = params[:community]
    @token = @community.split('?',2)

    # parse the community url into its pieces
    @parsed_url = URI.parse(@community)
   	@parsed_params = CGI.parse(@parsed_url.query)
    p "==========================="
   	p "Parsed " + @parsed_url.scheme
   	p "Parsed " + @parsed_url.host
   	p "Parsed " + @parsed_url.path
   	p "Parsed " + CGI.escape(@parsed_url.query.to_s).slice(4..-1)
   	p "==========================="

	response.set_cookie("scheme", :value => @parsed_url.scheme)
 	response.set_cookie("host", :value => @parsed_url.host)
 	response.set_cookie("path", :value => @parsed_url.path)
 	response.set_cookie("query", :value => CGI.escape(@parsed_url.query.to_s).slice(4..-1))

    p "==========================="
    p "Set Cookie " + request.cookies["scheme"]
    p "Set Cookie " + request.cookies["host"]
    p "Set Cookie " + request.cookies["path"]
    p "Set Cookie " + request.cookies["query"]
    p "==========================="

    # See if there is a covergirl cookie in the browser
    @cookie = request.cookies["covergirl"]

    # If we find one, we know they previously accepted the T&Cs so send them along otherwise send them to the T&Cs page
	# ... also, we want to check that they have accepted the current version of the terms
    p "=======Match?=============="
    if @cookie
    	p "COOKIE  " + @cookie
    else
    	p "COOKIE  None"
    end
    p "INBOUND " + request.cookies["scheme"] + "://" + request.cookies["host"] + request.cookies["path"] + "?c=" + request.cookies["query"].to_s + currentVersion


    if @cookie == request.cookies["scheme"] + "://" + request.cookies["host"] + request.cookies["path"] + "?c=" + request.cookies["query"].to_s + currentVersion
		@community = request.cookies["scheme"] + "://" + request.cookies["host"] + request.cookies["path"] + "?c=" + request.cookies["query"].to_s
	    p "======YES=================="
	   	p "redirecting to " + @community
   	    redirect @community
   	else
	    p "======NO==================="
		erb :terms
    end
end

get '/continue' do
	# This page is for users returning from ACCEPTING the T&Cs
	# reconstruct the target URL
	@community = request.cookies["scheme"] + "://" + request.cookies["host"] + request.cookies["path"] + "?c=" + request.cookies["query"].to_s

    # Setup the expiration variable that will go into the cookie... we're shooting for about a month
    @expiration = Time.now + (60 * 60 * 24 * 30)

    # Stamp the cookie with the community URL plus the current version and expiration date
    @cookieValue = @community + currentVersion
	response.set_cookie("covergirl", :value => @cookieValue, :expires => @expiration)

	# ... and off you go!
	p "redirecting to " + @community
	redirect @community
end

get '/exit' do
	# This pace is for users returning from DECLINING the T&Cs

    # ... and you are outta here!
    erb :exit
end

get '/goback' do
	# Reconstruct the original URL and send them back to the base path
	@community = request.cookies["scheme"] + "://" + request.cookies["host"] + request.cookies["path"] + "?c=" + request.cookies["query"].to_s

    p "==========================="
  	p request.cookies["query"].to_s
    p "==========================="

	redirect "/?community=" + @community

end