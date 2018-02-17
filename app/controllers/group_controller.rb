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
		group.leader = current_user #upon group creation, current_user is both assigned as group leader and added to group members list
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
		if @group.members.include?(current_user) #checks if current_user is part of group
			@prayers = @group.prayers.sort.reverse #if so, all of groups' prayers are collected
		else
			@prayers = @group.prayers.find_all{|prayer|prayer.public?}.sort.reverse #otherwise, only public prayers are collected
		end
		if !logged_in?
			flash.next[:error] = "Please log in"
			redirect "/login"
		end
		if @group.private? == false #checks if group is private
			erb :"groups/show" #if not, loads group show page
		elsif @group.private? == true && @group.members.any?{|member| member.id == current_user.id} #if so and current user is part of group, loads group show page
			erb :"groups/show"
		else
			flash.next[:error] = "You do not have access to view that group" #otherwise, current_user cannot view private group they are not a part of
			redirect '/groups'
		end
	end

	get '/groups/:id/edit' do
		@group = Group.find(params[:id])
		if !logged_in?
			flash.next[:error] = "Please log in"
			redirect "/login"
		end
		if @group.leader = current_user #only group leader can edit group
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
		if @group.members.include?(current_user) #user can't rejoin group they already are a part of
			flash.next[:error] = "You are already part of this group"
			redirect "/groups/#{@group.id}"
		elsif @group.private? #user cannot join a private group they are not a part of
			flash.next[:error] = "You do not have permission to join that private group"
			redirect "/groups"
		else
			erb :"/groups/join"
		end
	end

	post '/groups/:id/join' do
		group = Group.find(params[:id])
		group.members << current_user #adds current_user to group's member list
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
		if @group.leader ==current_user #prevents group leader to leave group
			flash.next[:error] = "You cannot leave a group you lead"
			redirect "/groups/#{@group.id}"
		elsif !@group.members.include?(current_user) #user cannot leave any group they are not a part of
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
		if logged_in? && @group.leader == current_user #only group leader can delete a group
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

	post '/groups/:id/add_member' do #searches through User db by username, email, and name to find a match and adds match to group's member list
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