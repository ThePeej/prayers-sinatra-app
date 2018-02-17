class GroupController <ApplicationController

	get '/groups' do 
		@groups = Group.all.find_all{|group|!group.private?}
		erb :"groups/index"
	end

	get '/groups/new' do
		if logged_in?
			erb :"groups/new"
		else
			flash.next[:error] = "Please log in"
			redirect "/login"
		end
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
		if @group.members.include?(current_user)
			@prayers = @group.prayers.sort.reverse
		else
			@prayers = @group.prayers.find_all{|prayer|prayer.public?}.sort.reverse
		end
		if !logged_in?
			flash.next[:error] = "Please log in"
			redirect "/login"
		end
		if @group.private? == false
			erb :"groups/show"
		elsif @group.private? == true && @group.members.any?{|member| member.id == current_user.id}
			erb :"groups/show"
		else
			flash.next[:error] = "You do not have access to view that group"
			redirect '/groups'
		end
	end

	get '/groups/:id/edit' do
		@group = Group.find(params[:id])
		if !logged_in?
			flash.next[:error] = "Please log in"
			redirect "/login"
		end
		if @group.leader = current_user
			erb :"groups/edit"
		else
			flash.next[:error] = "You do not have permission to edit this group"
			redirect "/groups/#{@group.id}"
		end
	end

	patch '/groups/:id' do
		group = Group.find(params[:id])
		if group.update(:name => params["name"], :description => params["description"], :private? => !!params["private"])
			flash.next[:message] = "#{group.name} successfully edited!"
			redirect "/groups/#{group.id}"
		else
			flash.next[:error] = "Group requires a name"
			redirect "/groups/#{group.id}/edit"
		end
	end

	get '/groups/:id/join' do
		@group = Group.find(params[:id])
		if !logged_in?
			flash.next[:error] = "Please log in"
			redirect "/login"
		end
		if @group.members.include?(current_user)
			flash.next[:error] = "You are already part of this group"
			redirect "/groups/#{@group.id}"
		elsif @group.private?
			flash.next[:error] = "You do not have permission to join that private group"
			redirect "/groups"
		else
			erb :"/groups/join"
		end
	end

	post '/groups/:id/join' do
		group = Group.find(params[:id])
		group.members << current_user
		group.save
		flash.next[:message] = "You've joined the group!"
		redirect "/groups/#{group.id}"
	end

	get '/groups/:id/leave' do
		@group = Group.find(params[:id])
		if !logged_in?
			flash.next[:error] = "Please log in"
			redirect "/login"
		end
		if @group.leader ==current_user
			flash.next[:error] = "You cannot leave a group you lead"
			redirect "/groups/#{@group.id}"
		elsif !@group.members.include?(current_user)
			if !@group.private?
				flash.next[:error] = "You are not part of this group"
				redirect "/groups/#{@group.id}"
			else
				flash.next[:error] = "You are not part of that private group"
				redirect "/groups"
			end
		else
			erb :"groups/leave"
		end
	end

	post '/groups/:id/leave' do
		group = Group.find(params[:id])
		group.members.delete(current_user)
		group.save
		flash.next[:message] = "You've left the group"
		redirect "/groups"
	end

	get '/groups/:id/delete' do
		@group = Group.find(params[:id])
		if logged_in? && @group.leader == current_user
			erb :"groups/delete"
		elsif logged_in?
			flash.next[:error] = "You do not have permission to delete this group"
			redirect "/groups/#{@group.id}"
		else
			flash.next[:error] = "Please log in"
			redirect "/login"
		end
	end

	delete '/groups/:id/delete' do
		group = Group.find(params[:id])
		group.destroy
		flash.next[:message] = "Group has been deleted"
		redirect "/groups"
	end

	get '/groups/:id/add_member' do
		redirect "/groups/#{params[:id]}"
	end

	post '/groups/:id/add_member' do
		group = Group.find(params[:id])
		if User.find_by(:username => params["add_member"]) || User.find_by(:email => params["add_member"])
			new_member = User.find_by(:username => params["add_member"]) if !!User.find_by(:username => params["add_member"])
			new_member = User.find_by(:email => params["add_member"]) if !!User.find_by(:email => params["add_member"])
			new_member = User.find_by(:name => params["add_member"]) if !!User.find_by(:email => params["add_member"])
			flash.next[:message] = "Added #{new_member.name} to the group!"
			group.members << new_member
		else
			flash.next[:error] = "Unable to find that person"
		end
		redirect "/groups/#{group.id}"
	end

end