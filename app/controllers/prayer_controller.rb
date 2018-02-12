class PrayerController < ApplicationController

	get '/prayers' do 
		@prayers = Prayer.all
		erb :"prayers/index"
	end

	get '/prayers/new' do
		erb :"prayers/new"
	end

	post '/prayers' do
		raise params.inspect
	end

end