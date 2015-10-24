# Define roles, user and IP address of deployment server
# role :name, %{[user]@[IP adde.]}
role :app, %w{<%= ENV["CHRISTIANRAILS_USER_PROD"] %>@<%= ENV["CHRISTIANRAILS_HOST_PROD"] %>}
role :web, %w{<%= ENV["CHRISTIANRAILS_USER_PROD"] %>@<%= ENV["CHRISTIANRAILS_HOST_PROD"] %>}
role :db,  %w{<%= ENV["CHRISTIANRAILS_USER_PROD"] %>@<%= ENV["CHRISTIANRAILS_HOST_PROD"] %>}

# Define server(s)
server '<%= ENV["CHRISTIANRAILS_HOST_PROD"] %>', user: '<%= ENV["CHRISTIANRAILS_USER_PROD"] %>', roles: %w{web}

# SSH Options
# See the example commented out section in the file
# for more options.
set :ssh_options, {
    forward_agent: false,
    auth_methods: %w(password),
    user: '<%= ENV["CHRISTIANRAILS_USER_PROD"] %>',
    password: '<%= ENV["CHRISTIANRAILS_PASS_PROD"] %>'
}