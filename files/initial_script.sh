#!/bin/bash

#This script is meant to install spark and jupyter notebook with
# all of their dependencies in an AWS virtual machine running Ubuntu
# it is meant to be executed at instance boot

USERNAME=ubuntu

echo "running update"
apt-get -qq update
echo "installing pip"
apt -qq install python3-pip -y
echo "installing jre"
apt-get -qq install default-jre -y
echo "installing scala"
apt-get -qq install scala -y
cd /home/$USERNAME
pwd
wget https://spark-demo-files.s3.amazonaws.com/requirements.txt
echo "install requirements"
pip3 install -q -r requirements.txt
wget http://archive.apache.org/dist/spark/spark-3.4.0/spark-3.4.0-bin-hadoop3.tgz
tar -zxf spark-3.4.0-bin-hadoop3.tgz
#cd spark-3.4.0-bin-hadoop3.tgz
mkdir /home/$USERNAME/certs
cd /home/$USERNAME/certs
pwd
wget https://spark-demo-files.s3.amazonaws.com/myCert.pem
pip3 install jupyter
su $USERNAME
#since restarting the shell is not recommended,
# execute jupyter from default location 
~/.local/bin/jupyter-notebook --generate-config
echo "c = get_config()
c.NotebookApp.certfile = '/home/$USERNAME/certs/myCert.pem'
c.NotebookApp.ip = '*'
c.NotebookApp.open_browser = False
c.NotebookApp.port = 8888" >> ~/.jupyter/jupyter_notebook_config.py