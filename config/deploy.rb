require 'capistrano-rbenv'
require 'capistrano-bundler'

set :application, 'christianrails'

set :scm, :git
set :repo_url, 'https://github.com/christiancodes/christianrails.git'

set :deploy_to, '/var/www/christianrails'

set :pty, true
set :format, :pretty

set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}

set :use_sudo, false

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.2.1'

set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails unicorn}
set :rbenv_roles, :all # default value

set :keep_releases, 5

set :linked_dirs, %w{ log }

namespace :deploy do

  # task :symlink_shared do
  #   system "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  # end

  desc 'Precompile assets'
  task :precompile do
    on roles :all do
      execute "cd /var/www/christianrails/current && RAILS_ENV=production #{fetch(:rbenv_prefix)} rake assets:precompile"
    end
  end

  desc 'Get the vars'
  task :get_vars do
    on roles :all do
      execute "cp /var/www/christianrails/releases/.application.yml /var/www/christianrails/current/config/application.yml"
    end
  end

  desc 'Migrate the DB'
  task :migrate do
    on roles :all do
      execute "cd /var/www/christianrails/current && RAILS_ENV=production #{fetch(:rbenv_prefix)} rake db:migrate"
    end
  end

  desc 'Restart unicorn'
  task :restart_uni do
    on roles :all do
      execute 'kill -9 `cat /var/www/christianrails/shared/pids/unicorn.pid`'
      execute 'rm /var/www/christianrails/shared/pids/unicorn.pid'
      execute "cd /var/www/christianrails/current && #{fetch(:rbenv_prefix)} bundle exec unicorn -c config/unicorn.rb -E production -D"
    end
  end

  # after :publishing, :recover
  # after :recover, :restart
  after :publishing, :precompile
  after :precompile, :get_vars
  after :get_vars, :migrate
  after :migrate, :restart_uni

end
