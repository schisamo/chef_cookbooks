#
# Cookbook Name:: mongodb
# Recipe:: default

case node[:platform]
when "debian","ubuntu"
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
  
  if !(::File.exists?("/tmp/#{node[:mongodb][:file_name]}.tgz")) && !(::File.directory?(node[:mongodb][:root]))
    Chef::Log.info "Downloading MongoDB from #{node[:mongodb][:url]}. This could take a while..."
    remote_file "/tmp/#{node[:mongodb][:file_name]}.tgz" do
      source node[:mongodb][:url]
      not_if { ::File.exists?("/tmp/#{node[:mongodb][:file_name]}.tgz") }
    end
  end

  bash "install-mongodb" do
    cwd "/tmp"
    code <<-EOH
    tar zxvf #{node[:mongodb][:file_name]}.tgz
    mv #{node[:mongodb][:file_name]} #{node[:mongodb][:root]}
    EOH
    not_if { ::File.directory?(node[:mongodb][:root]) }
  end

  # create init.d service
  template "/etc/init.d/mongodb" do
    source "init.sh.erb"
    owner "root"
    group "root"
    mode 0755
  end

when "centos","redhat","fedora"
  # A lot of the elements in the debian-style install are handled by 10gen's RPM package, so we don't have to define them ourselves.
  
  # Add the 10gen repo to local YUM config
  cookbook_file "/etc/yum.repos.d/mongo-10gen.repo" do
    source "mongo-10gen.repo"
    mode "0644"
  end

  # Install the version, as specified by the attributes. Installs dependant package 'mongo-10gen' tools.
  package "mongo-10gen-server" do
    version "#{node[:mongodb][:version]}-mongodb_1"
    # arch "#{node[:kernel][:machine]}"
  end

else
  nil
end

# Service name differs as well between platforms.
service "mongodb" do
  case node[:platform]
  when "debian","ubuntu"
    service_name "mongodb"
  when "centos","redhat","fedora"
    service_name "mongod"
  end
  supports :start => true, :stop => true, :restart => true
  action [ :enable ]
end

# create config directory and file
directory "#{node[:mongodb][:config_dir]}" do
  action :create
  owner "root"
  group "root"
  mode 0755
end
template "#{node[:mongodb][:config_file]}" do
  source "mongodb.conf.erb"
  owner "root"
  group "root"
  mode 0744
  notifies :restart, resources(:service => "mongodb")
end
