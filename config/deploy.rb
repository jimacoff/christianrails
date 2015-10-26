require 'capistrano-rbenv'

set :application, 'christianrails'

set :scm, :git
set :repo_url, 'https://github.com/christiancodes/christianrails.git'

set :deploy_to, '/var/www/christianrails'

set :pty, true
set :format, :pretty

set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}

# Set the post-deployment instructions here.
# Once the deployment is complete, Capistrano
# will begin performing them as described.
# To learn more about creating tasks,
# check out:
# http://capistranorb.com/

namespace :deploy do

  # task :symlink_shared do
  #   system "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  # end

  desc 'Precompile assets'
  task :precompile do
    on roles :all do
      execute 'cd /var/www/christianrails/current && RAILS_ENV=production bundle exec rake assets:precompile'
    end
  end

  desc 'Migrate the DB'
  task :migrate do
    on roles :all do
      execute 'cd /var/www/christianrails/current && RAILS_ENV=production bundle exec rake db:migrate'
    end
  end

  desc 'Restart unicorn'
  task :restart do
    on roles :all do
      execute 'kill -9 `cat ./tmp/pids/unicorn.pid`'
      execute 'bundle exec unicorn_rails -c ./unicorn.rb -E production -D'
    end 
  end

  # after :publishing, :symlink_shared
  after :publishing, :precompile
  after :precompile, :migrate
  after :migrate, :restart

end
