set :application, 'christianrails'

set :scm, :git
set :repo_url, 'https://github.com/christiancodes/christianrails.git'

set :deploy_to, '/var/www/christianrails'

set :pty, true
set :format, :pretty

# Set the post-deployment instructions here.
# Once the deployment is complete, Capistrano
# will begin performing them as described.
# To learn more about creating tasks,
# check out:
# http://capistranorb.com/

namespace: deploy do

  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

  desc 'Precompile assets'
  task :precompile do
    run "cd #{release_path} && RAILS_ENV=production bundle exec rake assets:precompile"
  end

  desc 'Migrate the DB'
  task :migrate do
    run "cd #{release_path} && RAILS_ENV=production bundle exec rake db:migrate"
  end

  desc 'Restart unicorn'
  task :restart do
    system "kill -9 `cat ./tmp/pids/unicorn.pid`"
    system "bundle exec unicorn_rails -c ./unicorn.rb -E #{Rails.env} -D"
  end

  after :publishing, :symlink_shared
  after :symlink_shared, :precompile
  after :precompile, :migrate
  after :migrate, :restart

end
