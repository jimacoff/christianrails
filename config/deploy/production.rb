# Define roles, user and IP address of deployment server
# role :name, %{[user]@[IP adde.]}
role :app, [ENV['CHRISTIANRAILS_USERHOST_PROD']]
role :web, [ENV['CHRISTIANRAILS_USERHOST_PROD']]
role :db,  [ENV['CHRISTIANRAILS_USERHOST_PROD']]

# Define server(s)
server ENV['CHRISTIANRAILS_HOST_PROD'], user: ENV['CHRISTIANRAILS_USER_PROD'], roles: %w{web}

# SSH Options
# See the example commented out section in the file
# for more options.
set :ssh_options, {
    forward_agent: false,
    auth_methods: %w(password),
    user: ENV['CHRISTIANRAILS_USER_PROD'],
    password: ENV['CHRISTIANRAILS_PASS_PROD']
}