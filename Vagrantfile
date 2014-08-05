# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "mwrock/Windows2012R2"
  config.vm.box_url = "https://vagrantcloud.com/mwrock/Windows2012R2/version/1/provider/hyperv.box"
  config.vm.synced_folder ".", "/chocolateypackages", disabled: true
  config.vm.guest = :windows
  config.vm.communicator = "winrm"
  config.winrm.username = "administrator"
  config.winrm.password = "Pass@word1"
end
