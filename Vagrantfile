Vagrant.configure("2") do |config|
  # same vagrant box for all nodes
  config.vm.box = "ubuntu/jammy64"
  config.vm.box_check_update = true
  # Defining the master node
  config.vm.define "master_node" do |master_node|
    master_node.vm.provider "virtualbox" do |vb|
       vb.gui = false
       vb.cpus = 3
       vb.memory = "5096"
       vb.name = "master_node"
    end
   # automatically install docker
   config.vm.provision "docker" do |d|
     d.post_install_provision "docker-compose", type: "shell", path: "scripts/install-docker-compose.sh"
   end

    master_node.vm.synced_folder ".", "/vagrant"
    master_node.vm.hostname = "master.local"
    master_node.vm.network :private_network, ip: "172.16.0.2", hostname: true
    master_node.vm.network :forwarded_port, guest: 8080, host: 8080, auto_correct: true
    master_node.vm.network :forwarded_port, guest: 8081, host: 8081, auto_correct: true
    master_node.vm.network :forwarded_port, guest: 8082, host: 8082, auto_correct: true
    # nginx-prometheus-exporter port
    master_node.vm.network :forwarded_port, guest: 9113, host: 9113, auto_correct: true
    # prometheus port
    master_node.vm.network :forwarded_port, guest: 9090, host: 9090, auto_correct: true
    # grafana port
    master_node.vm.network :forwarded_port, guest: 3000, host: 3000, auto_correct: true
    master_node.vm.provision "jenkins",type: "shell", path: "scripts/install-jenkins-git-java.sh"
  end
end
