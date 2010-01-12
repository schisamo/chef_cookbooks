#
# Cookbook Name:: scout_agent
# Recipe:: default

# create user and group
group node[:scout_agent][:group] do
  action [ :create, :manage ]
end
user node[:scout_agent][:user] do
  comment "Scout Agent"
  gid node[:scout_agent][:group]
  home "/home/#{node[:scout_agent][:user]}"
  supports :manage_home => true
  action [ :create, :manage ]
end

# install scout agent gem
gem_package "scout" do
  version node[:scout_agent][:version]
  action :install
end

if node[:scout_agent][:key]
  # initialize scout gem
  bash "initialize scout" do
    code <<-EOH
    #{node[:scout_agent][:scout_bin]} #{node[:scout_agent][:key]}
    EOH
    not_if do File.exist?("/var/spool/cron/crontabs/scout") end
  end
  
  # schedule scout agent to run via cron
  cron "scout_run" do
    user node[:scout_agent][:user]
    command "#{node[:scout_agent][:scout_bin]} #{node[:scout_agent][:key]}"
    only_if do File.exist?("/usr/bin/scout") end
  end
else
  Chef::Log.info "Add a [:scout_agent][:key] attribute to configure this node's Scout Agent"
end