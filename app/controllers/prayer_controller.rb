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
		# params = {"content"=>"Prayers for me to get over my cold", "public"=>"on", "group_id"=>["2", "3"]}
		# params = {"content"=>"TEST2", "anonymous"=>"on", "group_id"=>["1", "3"]}
		prayer = Prayer.new(:content => params["content"], :public? => !!params["public"], :anonymous? => !!params["anonymous"])
		prayer.author = current_user
		binding.pry

		if prayer.save
			flash.next[:greeting] = "Successfully posted a prayer!"
			redirect '/prayers'
		else
			flash.next[:error] = "Prayer post requires content"
			redirect '/prayers/new'
		end
		
	end

end