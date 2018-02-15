class UserController < ApplicationController

	get '/signup' do
		if logged_in?
			flash.next[:greeting] = "Already logged in as #{current_user.username}"
			redirect '/prayers'
		else

			erb :"users/new"
		end
	end

	post '/signup' do
		user = User.new(params)
		# requires unique email for all users
		if User.all.any?{|user|user.email.downcase == params["email"].downcase||user.username.downcase == params["username"].downcase}
			flash.next[:error] = "Username or email is already associated with an account"
			redirect "/signup"
		else
			if user.save
				session[:user_id] = user.id
				flash.next[:greeting] = "Hi there, #{user.username}"
				redirect '/prayers'
			else
				flash.next[:error] = "Username, email, and password are required to create an account."
				redirect '/signup'
			end
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
			erb :"users/account"
		else
			flash.next[:error] = "Please log in"
			redirect '/login'
		end
	end

	get '/users/:id' do
		@user = User.find(params[:id])
		erb :"users/show"
	end

	get '/users/:id/edit' do
		@user = User.find(params[:id])
		if @user == current_user
			erb :"users/edit"
		else
			flash.next[:error] = "You do not have permission to edit that account"
			redirect "/prayers"
		end
	end

	patch '/users/:id/edit' do
		user = User.find(params[:id])
		# requires unique email for all users
		if User.all.any?{|user|user.email.downcase == params["email"].downcase||user.username.downcase == params["username"].downcase}
			flash.next[:error] = "Username or email is already associated with an account"
		else
			if user.update(params)
				flash.next[:message] = "Account successfully edited!"
				redirect "/account"
			else
				flash.next[:error] = "Account requires username, email, and password"
				redirect "/users/#{user.id}/edit"
			end
		end
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