require './config/environment'
require 'sinatra/flash'
require 'pry'

class ApplicationController < Sinatra::Base

	configure do
		set :public_folder, 'public'
		set :views, 'app/views'
		enable :sessions
		set :session_secret, "password_security"
		register Sinatra::Flash
	end

	get '/' do
		erb :index
	end

	not_found do
		status 404
		erb :oops
	end

	helpers do
		def current_user #helper method to check currently logged in user throughout various routes
			User.find(session[:user_id])
		end

		def logged_in? #helper method to check if any user is logged in
			!!session[:user_id]
		end
	end

end