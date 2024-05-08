#!/bin/bash
exec > >(tee -i /var/log/user-data.log) #redirects the standard output >(): This construct is called process substitution. It allows the output of a command to be used as a file-like object.
exec 2>&1  #redirects the standard error 
sudo apt update -y
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
sudo apt install git -y 
mkdir Ansible && cd Ansible
pwd
git clone https://github.com/MatforZo/ANSIBLE.git
cd ANSIBLE
ansible-playbook -i localhost Jenkins_install_playbook.yml