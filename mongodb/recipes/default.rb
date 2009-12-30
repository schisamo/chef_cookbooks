#
# Cookbook Name:: mongodb
# Recipe:: default
mongodb_filename = "mongodb-linux-#{node[:mongodb][:architecture]}-#{node[:mongodb][:version]}"
mongodb_name = "mongodb-#{node[:mongodb][:version]}"

bash "install-mongodb" do
  user "root"
  cwd "/tmp"
  code <<-EOH
  curl -O http://downloads.mongodb.org/linux/#{mongodb_filename}.tgz
  tar zxvf #{mongodb_filename}.tgz
  mv #{mongodb_filename} #{node[:mongodb][:root]}
  rm #{mongodb_filename}.tgz
  EOH
  not_if { File.directory?(node[:mongodb][:root]) }
end

group node[:mongodb][:group] do
  action [ :create, :manage ]
end

user node[:mongodb][:user] do
  comment "MongoDB Server"
  gid node[:mongodb][:group]
  home node[:mongodb][:root]
  action [ :create, :manage ]
end

[node[:mongodb][:log_dir], node[:mongodb][:data_dir], node[:mongodb][:pid_dir]].each do |dir|
  directory dir do
    owner node[:mongodb][:user]
    group node[:mongodb][:group]
    mode 0755
    recursive true
    action :create
    not_if { File.directory?(dir) }
  end
end

template "/etc/init.d/mongodb" do
  source "init.sh.erb"
  owner "root"
  group "root"
  mode 0700
  variables(:node => node)
end

service "mongodb" do
  supports :start => true, :stop => true, :restart => true
  action [ :enable, :start ]
end
