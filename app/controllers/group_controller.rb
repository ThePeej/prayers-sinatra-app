class GroupController <ApplicationController

	get '/groups' do 
		@groups = Group.find_by(:private => false)

		erb :"groups/index"
	end