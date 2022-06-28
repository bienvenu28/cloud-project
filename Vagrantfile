Vagrant.configure("2") do |config|
  # same vagrant box for all nodes
  config.vm.box = "ubuntu/impish64"
  config.vm.box_check_update = true

 # Defining the build node
  config.vm.define "build_node" do |build_node|
    build_node.vm.provider "virtualbox" do |vb|
        vb.gui = false
        vb.cpus = 3
        vb.memory = "5096"
        vb.name = "build_node"
    end
    build_node.vm.hostname = "build.local"
    build_node.vm.network :private_network, ip: "172.16.0.4", hostname: true
    build_node.vm.provision "java", type: "shell", path: "scripts/install-java.sh"
    build_node.vm.provision "git", type: "shell", path: "scripts/install-git.sh"
    build_node.vm.provision "auth", type: "shell", path: "scripts/enable-password-auth.sh"
  end

  # Defining the app node
  config.vm.define "app_node" do |app_node|
    app_node.vm.provider "virtualbox" do |vb|
        vb.gui = false
        vb.cpus = 3
        vb.memory = "5096"
        vb.name = "app_node"
    end
    app_node.vm.hostname = "app.local"
    app_node.vm.network :private_network, ip: "172.16.0.3", hostname: true
    app_node.vm.network :forwarded_port, guest: 80, host: 8081, auto_correct: true
    app_node.vm.provision "java", type: "shell", path: "scripts/install-java.sh"
    app_node.vm.provision "git", type: "shell", path: "scripts/install-git.sh"
    app_node.vm.provision "auth", type: "shell", path: "scripts/enable-password-auth.sh"
  end

  # Defining the master node
  config.vm.define "master_node" do |master_node|
    master_node.vm.provider "virtualbox" do |vb|
       vb.gui = false
       vb.cpus = 3
       vb.memory = "5096"
       vb.name = "master_node"
    end
    master_node.vm.synced_folder ".", "/vagrant"
    master_node.vm.hostname = "master.local"
    master_node.vm.network "private_network", ip: "172.16.0.2", hostname: true
    master_node.vm.network "forwarded_port", guest: 8080, host: 8080, auto_correct: true
    master_node.vm.provision "jenkins",type: "shell", path: "scripts/install-jenkins-git-java.sh"
    # configure a local dns
    master_node.vm.provision "dns", type: "shell", inline: 'echo "172.16.0.3 app.local" >> /etc/hosts && echo "172.16.0.4 build.local" >> /etc/hosts'
  end
end
