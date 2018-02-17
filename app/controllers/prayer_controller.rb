class PrayerController < ApplicationController

	get '/prayers' do 
		@prayers = Prayer.all.find_all{|prayer| prayer.public?}.sort.reverse #collects and displays only public prayers
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
		prayer = Prayer.new(:overview => params["overview"],:details => params["details"], :public? => !!params["public"], :anonymous? => !!params["anonymous"])
		prayer.author = current_user

		if prayer.save
			params["group_id"].each {|id|Group.find(id).prayers << prayer} if !!params["group_id"] #adds new prayer to each group specified in group_id array

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
		elsif @prayer.public? || @prayer.author == current_user || !(@prayer.groups & current_user.groups) #checks if prayer is either public, was shared by current  user, or if current user is in a group where prayer was shared
			erb :"prayers/show"
		else
			flash.next[:error] = "You do not have access to view that prayer"
			redirect "/prayers"
		end
	end

	get '/prayers/:id/edit' do
		@prayer = Prayer.find(params[:id])
		if !logged_in?
			flash.next[:error] = "Please log in"
			redirect "/login"
		end
		if @prayer.author == current_user #only prayer author can edit prayer
			erb :"prayers/edit"
		else
			flash.next[:error] = "You do not have permission to edit this prayer"
			redirect "/prayers"
		end
	end

	patch '/prayers/:id' do
		prayer = Prayer.find(params[:id])
		
		if prayer.update(:overview => params["overview"],:details => params["details"], :public? => !!params["public"], :anonymous? => !!params["anonymous"])
			current_user.groups.each do |group| #deletes prayer from all groups that it is in (resets all groups)
				if group.prayers.include?(prayer)
					group.prayers.delete(prayer)
				end
			end
			params["group_id"].each {|id|Group.find(id).prayers << prayer} if !!params["group_id"] #re-adds prayer only to groups specified in newly revised group_id array
			redirect "/prayers/#{prayer.id}"
		else
			flash.next[:error] = "Prayer post requires overview"
			redirect "/prayers/#{prayer.id}/edit"
		end

	end

	# prayer delete confirmation
	get '/prayers/:id/delete' do
		@prayer = Prayer.find(params[:id])
		if logged_in? && @prayer.author == current_user #only prayer author can delete prayer
			erb :"prayers/delete"
		elsif logged_in?
			flash.next[:error] = "You do not have permission to delete this prayer"
			redirect "/prayers"
		else
			flash.next[:error] = "Please log in"
			redirect "/login"
		end
	end


	delete '/prayers/:id/delete' do
		prayer = Prayer.find(params[:id])
		prayer.destroy
		flash.next[:greeting] = "Prayer was deleted"
		redirect "/prayers"
	end


end