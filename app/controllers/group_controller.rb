class GroupController <ApplicationController

	get '/groups' do 
		@groups = Group.all
		erb :"groups/index"
	end

	get '/groups/new' do
		erb :"groups/new"
	end

	post '/groups' do
		group = Group.new(:name => params["name"], :description => params["description"], :private? => !!params["private"])
		group.leader = current_user
		group.members << current_user
		if group.save
			redirect "/groups/#{group.id}"
		else
			flash.next[:error] = "New prayer groups require a name"
			redirect '/groups/new'
		end
	end

	get '/groups/:id' do
		@group = Group.find(params[:id])
		if @group.private? == false
			erb :"groups/show"
		elsif @group.private? == true && @group.members.any?{|member| member.id == current_user.id}
			erb :"groups/show"
		else
			flash.next[:greeting] = "You do not have access to view that group"
			redirect '/groups'
		end
	end

	get '/groups/:id/edit' do
		@group = Group.find(params[:id])
		if @group.leader = current_user
			flash.next[:message] = "#{@group.name} successfully created!"
			erb :"groups/edit"
		else
			flash.next[:error] = "You do not have permission to edit this group"
			redirect "/groups/#{@group.id}"
		end
	end

	patch '/groups/:id' do
		group = Group.find(params[:id])
		group.update(:name => params["name"], :description => params["description"], :private? => !!params["private"])
		flash.next[:message] = "#{group.name} successfully edited!"
		redirect "/groups/#{group.id}"
	end

end