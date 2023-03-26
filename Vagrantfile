Vagrant.configure("2") do |config|
  # same vagrant box for all nodes
  config.vm.box = "ubuntu/jammy64"
  config.vm.box_check_update = true
  # Defining the master node
  config.vm.define "cloud_node" do |cloud_node|
    cloud_node.vm.provider "virtualbox" do |vb|
       vb.gui = false
       vb.cpus = 3
       vb.memory = "5096"
       vb.name = "cloud_node"
    end
    # automatically install docker
    config.vm.provision "docker"
    # configure Minikube
    cloud_node.vm.define "minikube" do |minikube|
      minikube.vm.box = "generic/ubuntu2004"
      minikube.vm.hostname = "minikube.local"
      minikube.vm.network :private_network, ip: "172.16.0.3", hostname: true
      minikube.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
        vb.cpus = 2
      end
      # provision Minikube with kubectl and Helm
      minikube.vm.provision "shell", inline: <<-SHELL
        curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
        sudo install minikube-linux-amd64 /usr/local/bin/minikube
        sudo minikube start --driver=none
        curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
        SHELL
    end
    # configure the cloud_node
    cloud_node.vm.synced_folder ".", "/vagrant"
    cloud_node.vm.hostname = "cloud.local"
    cloud_node.vm.network :private_network, ip: "172.16.0.2", hostname: true
    cloud_node.vm.network :forwarded_port, guest: 8080, host: 8080, auto_correct: true
    cloud_node.vm.network :forwarded_port, guest: 8081, host: 8081, auto_correct: true
    cloud_node.vm.network :forwarded_port, guest: 8082, host: 8082, auto_correct: true
    cloud_node.vm.provision "jenkins",type: "shell", path: "scripts/install-jenkins-git-java.sh"
  end
end
