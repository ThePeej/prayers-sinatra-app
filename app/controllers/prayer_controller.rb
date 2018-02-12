class PrayerController < ApplicationController

	get 'prayers' do 
		erb :"prayers/index"
	end

end