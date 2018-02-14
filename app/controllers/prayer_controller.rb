class PrayerController < ApplicationController

	get '/prayers' do 
		@prayers = Prayer.all
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

end