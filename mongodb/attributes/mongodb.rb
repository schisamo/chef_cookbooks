
set_unless[:mongodb][:bind_address] = "127.0.0.1"
set_unless[:mongodb][:port] = "27017"

set_unless[:mongodb][:version] = '1.8.2'
set_unless[:mongodb][:file_name] = "mongodb-linux-#{kernel[:machine] || 'i686'}-#{mongodb[:version]}"
set_unless[:mongodb][:url] = "http://downloads.mongodb.org/linux/#{mongodb[:file_name]}.tgz"

case platform
when "debian","ubuntu"
  set_unless[:mongodb][:user] = "mongodb"
  set_unless[:mongodb][:group] = "mongodb"
  set_unless[:mongodb][:log_dir] = "/var/log/mongodb"
  set_unless[:mongodb][:log_file] = "/var/log/mongodb/mongodb.log"
  set_unless[:mongodb][:data_dir] = "/var/lib/mongodb"
  set_unless[:mongodb][:config_dir] = "/etc/mongodb"
  set_unless[:mongodb][:config_file] = "/etc/mongodb/mongodb.conf"
  set_unless[:mongodb][:root] = "/usr/local/mongodb"
  set_unless[:mongodb][:pid_dir] = "/var/run"
when "redhat","centos","fedora"
  # many of these attributes should probably not be used, as they are created by the RPM, but declaring them here.
  set_unless[:mongodb][:user] = "mongod"
  set_unless[:mongodb][:group] = "mongod"
  set_unless[:mongodb][:log_dir] = "/var/log/mongo"
  set_unless[:mongodb][:log_file] = "/var/log/mongo/mongod.log"
  set_unless[:mongodb][:data_dir] = "/var/lib/mongo"
  set_unless[:mongodb][:config_dir] = "/etc"
  set_unless[:mongodb][:config_file] = "/etc/mongod.conf"
  set_unless[:mongodb][:root] = "/usr/bin"
  set_unless[:mongodb][:pid_dir] = "/var/run/mongo"
else
  nil
end