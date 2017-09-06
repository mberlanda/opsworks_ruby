# frozen_string_literal: true

#
# Cookbook Name:: opsworks_ruby
# Recipe:: whenever
#

prepare_recipe

execute 'delete existing crontabs' do
  user node['deployer']['user'] || 'root'
  command 'bash -c "crontab -r || exit 0"'
end

every_enabled_application do |app|
  deploy_dir = deploy_dir(app)
  release_path = "#{deploy_dir}/current"

  execute 'create new crontabs from whenever gem' do
    command 'RAILS_ENV=production bin/bundle exec whenever --update-crontab'
    user node['deployer']['user'] || 'root'
    cwd release_path
  end
end
