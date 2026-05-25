#!/bin/bash
component=$1
env=$2

# Expand disk and filesystem

growpart /dev/nvme0n1 4
pvresize /dev/nvme0n1p4
lvextend -l +50%FREE /dev/RootVG/homeVol
xfs_growfs /home
dnf install ansible cloud-utils-growpart -y
# ansible-pull -U https://github.com/jrjaswanth-spec/ansible-roboshop-roles-tf.git -e component=$component main.yaml

REPO_URL=https://github.com/jrjaswanth-spec/ansible-roboshop-roles-tf.git
REPO_DIR=/opt/roboshop/ansible
ANSIBLE_DIR=/opt/roboshop/ansible/ansible-roboshop-roles-tf


mkdir -p $REPO_DIR
mkdir -p /var/log/roboshop/

touch /var/log/roboshop/ansible.log
chmod 777 /var/log/roboshop/ansible.log

cd $REPO_DIR

# check if ansible repo is already cloned or not

if [ -d $ANSIBLE_DIR ]; then 

    cd $ANSIBLE_DIR
    git pull
else
    
    git clone $REPO_URL
    cd $ANSIBLE_DIR
fi    


ansible-playbook -e component=$component -e env=$env main.yaml