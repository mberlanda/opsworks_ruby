# frozen_string_literal: true
#
# Cookbook Name:: opsworks_ruby
# Recipe:: whenever
#

prepare_recipe

execute 'delete existing crontabs' do
  user node['deployer']['user'] || 'root'
  command 'crontab -r'
end

every_enabled_application.each do |application|
  app_deploy_dir = deploy_dir(application)
  latest_release = Dir.glob("#{app_deploy_dir}/*").map { |d| d.gsub("#{app_deploy_dir}/", '').to_i }.max.to_s

  execute 'create new crontabs from whenever gem' do
    command "cd #{app_deploy_dir}/#{latest_release} && RAILS_ENV=production bin/bundle exec whenever --update-crontab"
    user node['deployer']['user'] || 'root'
  end
end
