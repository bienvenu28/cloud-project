#!/bin/bash
# Install docker on linux ubuntu 22.04
sudo apt update
sudo apt install docker.io
sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo docker version
sudo usermod -aG docker vagrant
