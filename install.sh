#!/bin/bash
set -e

# Setup source code path
read -p "Please enter your catkin workspace (default=\$HOME/catkin_ws): " catkinWS
catkinWS=${catkinWS:-$HOME/catkin_ws}
echo "catkinWS is set to: ${catkinWS}"

if [ -d $catkinWS/src ]; then
	echo "source directory exist" 
else
	echo "source directory doesn't exist, automatically create one at follwoing path:\n  $catkinWS/src"
	mkdir -p  $catkinWS/src
fi

# clone 
#git clone --recurse-submodules https://github.com/lentychang/thesis.git $catkinWS/src/thesis

# check if docker is installed
if [ -x "$(command -v docker)" ]; then
        echo "Docker is installed"
else
	echo "Docker not installed or your are not in docker group"
	exit 1
fi

# Download Models
wget -O /tmp/thesis_models.tar.gz "https://docs.google.com/uc?export=download&id=1hu24fzK6UWyHuMvjTJyuWSYJhqoMSfFP"
if ! [ -d $HOME/exchange ]; then
      mkdir -p $HOME/exchange
fi      
tar -xzvf /tmp/thesis_models.tar.gz -C $HOME/exchange/



#[TODO]
# nvidia version is fixed to nvidia-384, change to auto grep on host machine or
# use nvdia-docker?

# build images
echo "Start to build docker images, it might takes more than 20mins..."
# nvdia is related to whether you can launch GUI in container, if you have nvidia gpu card
read -p "Is there nvidia gpu on your machine? [y/n]" yn 
case $yn in
        [Yy]* ) enable_nvdia=true;
        [Nn]* ) enable_nvdia=false;
        * ) echo "Please answer yes or no.";;
esac
cd $catkinWS/src/thesis/bringups
# start build image
./init_build.sh $enable_nvdia

