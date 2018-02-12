class UserController < ApplicationController

	get '/signup' do
		if logged_in?
			redirect '/prayers'
		else
			erb :"users/new"
		end
	end

	post '/signup' do
		user = User.new(params)
		if user.save
			session[:user_id] = user.id
			flash.next[:greeting] = "Hi there, #{user.username}"
			redirect '/prayers'
		else
			flash.next[:error] = "Username, email, and password are required to create an account."
			redirect '/signup'
		end
	end

	get '/login' do
		if logged_in?
			flash.next[:greeting] = "Already logged in as #{current_user.username}"
			redirect '/prayers'
		else
			erb :"users/login"
		end
	end

	post '/login' do
		user = User.find_by(:username => params["username"])

	    if user && user.authenticate(params["password"])
	        session[:user_id] = user.id
	        flash.next[:greeting] = "Welcome back, #{user.username}"
	        redirect "/prayers"
	    else
	    	flash.next[:error] = "Login Failed. Please Try Again."
	        redirect "/login"
	 	end
 	 end

	get '/account' do
		if logged_in?
			@user = current_user
			erb :"users/show"
		else
			redirect '/login'
		end
	end

	get '/users/:id/edit' do
		@user = User.find(params[:id])
	end

	get '/logout' do
		if logged_in?
			session.clear
			flash.next[:greeting] = "You've been logged out"
			redirect '/prayers'
		else
			flash.next[:greeting] = "You were not logged in"
			redirect '/prayers'
		end
	end

end