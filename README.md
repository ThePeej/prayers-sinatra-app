# Prayers

## A Sinatra Portfolio Project for Flatiron School

The project is a simple CRUD app that allows a user to create, read, update, and destroy prayers posted on the app. This project is built with the intent to eventually deploy a fully functioning social website.

### Functionality Overview:
	- User will have many groups, and many prayers.
		- User can sign up for, log into, edit, and delete his or her account.
		- User can create, edit, and delete groups.
		- User can create, edit, and delete prayers
	- Groups will have one leader, many members, many prayers through members.
		- Only specific prayers posted to each group will be visible from group's page.
		- Only non-private groups will be displayed on the group index page.
		- Users cannot manually join a private group
	- Prayers will belong to a memember, and will have many groups.
		- Prayers can be posted anonymously
		- Prayers can be posted only to specific groups that the user is part of.
		- Prayers can be posted to the "public" prayers index page.



Built using Ruby Sinatra, ActiveRecord, SQLite3, Bulma CSS framework


### Installation Instructions

Fork/Clone this repo, and then navigate to the repo directory in your terminal.

Then, run `bundle install` to install all gem dependencies.

Run all rake migrations with `rake db:migrate`

Finally, start up a server using `shotgun` and navigate to the provided url