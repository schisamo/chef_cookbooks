set_unless[:mongodb][:version] = '1.2.0'
set_unless[:mongodb][:architecture] = kernel[:machine] || 'i686'

set_unless[:mongodb][:bind_address] = "127.0.0.1"
set_unless[:mongodb][:port] = "27017"

set_unless[:mongodb][:user] = "mongodb"
set_unless[:mongodb][:group] = "mongodb"

set_unless[:mongodb][:root] = "/usr/local/mongodb"
set_unless[:mongodb][:data_dir] = "/var/lib/mongodb"
set_unless[:mongodb][:log_dir] = "/var/log/mongodb"
set_unless[:mongodb][:pid_dir] = "/var/run/mongodb"
