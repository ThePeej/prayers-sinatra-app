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
			flash.next[:message] = "Username, email, and password are required to create an account."
			redirect '/signup'
		end
	end

end