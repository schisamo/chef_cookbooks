maintainer        "Seth Chisaore"
maintainer_email  "schisamo@gmail.com"
license           "Apache 2.0"
description       "Installs and configures the Scout Agent"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.1"

%w{ debian ubuntu}.each do |os|
  supports os
end