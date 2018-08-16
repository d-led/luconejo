Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.provision "shell", privileged: true, inline: <<-SHELL
    apt-get update
    apt-get -y install git build-essential g++ libcpprest-dev liblua5.3-dev lua5.3 rabbitmq-server luarocks librabbitmq-dev libboost-all-dev cmake
    luarocks install busted
    echo cd /vagrant >> `pwd`/.profile
  SHELL

  config.vm.provision "shell", privileged: false, inline: <<-SHELL

  SHELL

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
  end
end
