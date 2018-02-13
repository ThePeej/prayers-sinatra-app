class GroupController <ApplicationController

	get '/groups' do 
		@groups = Group.all
		erb :"groups/index"
	end

	get '/groups/new' do
		erb :"groups/new"
	end

	post '/groups' do
		group = Group.new(:name => params["name"], :description => params["description"])
		group.private == false if !!params["public"]
		group.leader = current_user
		group.users << current_user
		if group.save
			redirect "/groups/#{group.id}"
		else
			flash.next[:error] = "New prayer groups require a name"
			redirect '/groups/new'
		end
	end

	get '/groups/:id' do
		@group = Group.find(params[:id])
		# binding.pry
		if @group.private == false
			erb :"groups/show"
		elsif @group.private == true && @group.users.any?{|user| user.id == current_user.id}
			erb :"groups/show"
		else
			flash.next[:greeting] = "You do not have access to view that group"
			redirect '/groups'
		end
	end

end