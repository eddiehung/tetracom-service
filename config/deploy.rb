set :application, 'tetracom-service'
set :repo_url, 'git@github.com:custom-computing-ic/tetracom-service.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/var/www/tetracom-service'
set :scm, :git

# set :format, :pretty
# set :log_level, :debug
set :pty, true

# set :use_sudo, false
# set :user, "cpc10"
# set :scm_passphrase, "password"
# set :deploy_via, :copy
# set :ssh_options, { :forward_agent => true, :port => 22 }

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :default_environment, {
	'PATH' => "/usr/local/rvm/rubies/ruby-2.1.1/bin:$PATH",
	'RUBY_VERSION' => 'ruby 2.1.1',
	'GEM_HOME'     => '/usr/local/rvm/gems/ruby-2.1.1',
	'GEM_PATH'     => '/usr/local/rvm/gems/ruby-2.1.1',
	'BUNDLE_PATH'  => '/usr/local/rvm/gems/ruby-2.1.1'  # If you are using bundler.
}
set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end
