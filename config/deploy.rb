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
set :rbenv_ruby, '2.1.2'

set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails unicorn}
set :rbenv_roles, :all # default value

namespace :deploy do

  # task :symlink_shared do
  #   system "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  # end

  # desc 'Bundle'
  # task :bundle do
  #   on roles :all do
  #     execute 'cd /var/www/christianrails/current && gem install bundler'
  #     execute 'bundle install'
  #   end
  # end

  desc 'Precompile assets'
  task :precompile do
    on roles :all do
      execute 'cd /var/www/christianrails/current && RAILS_ENV=production rake assets:precompile'
    end
  end

  desc 'Migrate the DB'
  task :migrate do
    on roles :all do
      execute 'cd /var/www/christianrails/current && RAILS_ENV=production rake db:migrate'
    end
  end

  desc 'Restart unicorn'
  task :restart do
    on roles :all do
      execute 'kill -9 `cat ./tmp/pids/unicorn.pid`'
      execute 'unicorn_rails -c ./unicorn.rb -E production -D'
    end 
  end

  after :publishing, :precompile
  #after :bundle, :precompile
  after :precompile, :migrate
  after :migrate, :restart

end
