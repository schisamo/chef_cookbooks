maintainer        "Seth Chisaore"
maintainer_email  "schisamo@gmail.com"
license           "Apache 2.0"
description       "Configures MongoDB"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.2"

recipe "mongodb","Installs mongodb server"

%w{ debian ubuntu centos redhat fedora }.each do |os|
  supports os
end