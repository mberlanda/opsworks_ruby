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
  deploy_to = deploy_dir(app)
  releases = Dir[File.join(deploy_to, 'releases', '*')].map { |fp| fp.split('/').last }
  release_path = File.join(deploy_to, 'releases', releases.map(&:to_i).max.to_s)

  execute 'create new crontabs from whenever gem' do
    command 'RAILS_ENV=production bin/bundle exec whenever --update-crontab'
    user node['deployer']['user'] || 'root'
    cwd release_path
  end
end
