#!/usr/bin/bash

echo "### GENERATE MASTER NODE SSH KEYS ###"
ssh-keygen -t ecdsa -f /home/vagrant/.ssh/id_ecdsa
# Set vagrant as ownership
chown -R vagrant:vagrant /home/vagrant/.ssh

sudo apt install sshpass
echo "### SEND PUBLIC KEY ON APP NODE"
sshpass -p vagrant ssh-copy-id -i /home/vagrant/.ssh/id_ecdsa -o StrictHostKeyChecking=no vagrant@app.local

echo "### SEND PUBLIC KEY ON BUILD NODE"
sshpass -p vagrant ssh-copy-id -i /home/vagrant/.ssh/id_ecdsa -o StrictHostKeyChecking=no vagrant@build.local

sudo mkdir -p /var/lib/jenkins/.ssh

sudo cp /home/vagrant/.ssh/known_hosts /var/lib/jenkins/.ssh/

echo "### SSH CONFIG FINISHED ###"
