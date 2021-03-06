class UserController < ApplicationController

	get '/signup' do
		if logged_in?
			flash.next[:greeting] = "Already logged in as #{current_user.username}" #does not allow logged_in user to sign up
			redirect '/prayers'
		else

			erb :"users/new"
		end
	end

	post '/signup' do
		user = User.new(params)
		# requires unique email for all users
		if User.all.any?{|user|user.email.downcase == params["email"].downcase||user.username.downcase == params["username"].downcase} #checks if existing user has matching email or username
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
		if @user == current_user #user can only edit their own account
			erb :"users/edit"
		else
			flash.next[:error] = "You do not have permission to edit that account"
			redirect "/prayers"
		end
	end

	patch '/users/:id' do
		user = User.find(params[:id]) 
		# requires unique email and username for all users
		if user.email != params["email"] && User.all.any?{|user|user.email.downcase == params["email"].downcase}

			flash.next[:error] = "Email is already associated with an account"
			redirect "/users/#{user.id}/edit"

		elsif user.username != params["username"] && User.all.any?{|user|user.username.downcase == params["username"].downcase}

			flash.next[:error] = "Username is already associated with an account"
			redirect "/users/#{user.id}/edit"

		else
			if user.update(:username => params["username"], :email => params["email"], :password => params["password"], :name => params["name"], :church => params["church"], :verse => params["verse"])
				flash.next[:message] = "Account successfully edited!"
				redirect "/account"
			else
				flash.next[:error] = "Account requires username, email, and password"
				redirect "/users/#{user.id}/edit"
			end
		end
	end

	get '/users/:id/delete' do
		@user = User.find(params[:id])
		if @user == current_user #users can only delete their own account
			erb :"users/delete"
		else
			flash.next[:error] = "You do not have permission to delete that account"
			redirect "/prayers"
		end
	end

	delete '/users/:id/delete' do
		user = User.find(params[:id])
		user.prayers.destroy_all #user prayers are deleted first
		user.lead_groups.destroy_all #then groups that user leads
		user.destroy #then finally user is deleted
		session.clear #logs out of site
		flash.next[:greeting] = "Account has been deleted"
		redirect to '/prayers'
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