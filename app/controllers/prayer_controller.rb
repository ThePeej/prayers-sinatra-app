class PrayerController < ApplicationController

	get '/prayers' do 
		@prayers = Prayer.all
		erb :"prayers/index"
	end

	get '/prayers/new' do
		erb :"prayers/new"
	end

	post '/prayers' do
		# params = {"content"=>"Prayers for me to get over my cold", "public"=>"on", "group_id"=>["2", "3"]}
		# params = {"content"=>"TEST2", "anonymous"=>"on", "group_id"=>["1", "3"]}
		prayer = Prayer.new(:content => params["content"], :public? => !!params["public"], :anonymous? => !!params["anonymous"])
		binding.pry
	end

end