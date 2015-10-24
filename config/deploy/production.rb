# Define roles, user and IP address of deployment server
# role :name, %{[user]@[IP adde.]}
role :app, %w{<%= ENV["CHRISTIANRAILS_USER"] %>@<%= ENV["CHRISTIANRAILS_SERVER"] %>}
role :web, %w{<%= ENV["CHRISTIANRAILS_USER"] %>@<%= ENV["CHRISTIANRAILS_SERVER"] %>}
role :db,  %w{<%= ENV["CHRISTIANRAILS_USER"] %>@<%= ENV["CHRISTIANRAILS_SERVER"] %>}

# Define server(s)
server '<%= ENV["CHRISTIANRAILS_SERVER"] %>', user: '<%= ENV["CHRISTIANRAILS_USER"] %>', roles: %w{web}

# SSH Options
# See the example commented out section in the file
# for more options.
set :ssh_options, {
    forward_agent: false,
    auth_methods: %w(password),
    user: '<%= ENV["CHRISTIANRAILS_USER"] %>',
    password: '<%= ENV["CHRISTIANRAILS_PW"] %>'
}