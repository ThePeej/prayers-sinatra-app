class UserController < ApplicationController

	get '/signup' do 
		if logged_in?
			redirect '/prayers'
		else
			erb :"users/new"
		end
	end

	post '/signup' do
		raise params.inspect
		user = User.new(params)
		if user.save
			session[:user_id] = user.id
			redirect '/prayers'
		else
			flash[:message] = "Username, email, and password are required to create an account."
			redirect '/signup'
		end
	end

end