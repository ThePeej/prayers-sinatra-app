class PrayerController < ApplicationController

	get '/prayers' do 
		@prayers = Prayer.all.find_all{|prayer| prayer.public?}
		erb :"prayers/index"
	end

	get '/prayers/new' do
		if logged_in?
			erb :"prayers/new"
		else
			flash.next[:error] = "Please log in"
			redirect "/login"
		end
	end

	post '/prayers' do
		prayer = Prayer.new(:overview => params["overview"],:description => params["description"], :public? => !!params["public"], :anonymous? => !!params["anonymous"])
		prayer.author = current_user

		if prayer.save
			# params["group_id"].each do |id| #after saving prayer, add prayer to all groups selected in New Prayer form
			# 	group = Group.find(id)
			# 	group.prayers << prayer
			# 	group.save
			# end
			flash.next[:greeting] = "Successfully posted a prayer!"
			redirect '/prayers'
		else
			flash.next[:error] = "Prayer post requires overview"
			redirect '/prayers/new'
		end
	end

	get '/prayers/:id' do
		@prayer = Prayer.find(params[:id])
		if !logged_in?
			flash.next[:error] = "Please log in"
			redirect "/login"
		elsif @prayer.public? || @prayer.author == current_user
			erb :"prayers/show"
		else
			flash.next[:error] = "You do not have access to view that prayer"
			redirect "/prayers"
		end
	end

end