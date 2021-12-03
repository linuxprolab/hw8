Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.synced_folder ".", "/vagrant", type: "rsync", disabled: true
  config.vm.provision "file", source: "./etc", destination: "~/" 
  config.vm.provision "file", source: "./opt", destination: "~/"
  config.vm.provision "file", source: "./var", destination: "~/"
  config.vm.provision "file", source: "./response.varfile", destination: "~/"
  config.vm.provision "shell",path: "provision.sh", privileged: true
end
