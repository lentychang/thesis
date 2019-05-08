#!/bin/bash
set -e

# Setup source code path
read -p "Please enter your catkin workspace (default=\$HOME/catkin_ws): " catkinWS
catkinWS=${catkinWS:-$HOME/catkin_ws}
echo "catkinWS is set to: ${catkinWS}"

# setup model dir
read -p "Please enter where you want to put model data on host (default=\$HOME/exchange): " modelDir
modelDir=${modelDir:-$HOME/exchange}

# nvdia is related to whether you can launch GUI in container, if you have nvidia gpu card
read -p "Is there nvidia gpu on your machine? [y/n]" yn 
case $yn in
        [Yy]* ) enable_nvdia=true;
        [Nn]* ) enable_nvdia=false;
        * ) echo "Please answer yes or no.";;
esac

if [ -d $catkinWS/src ]; then
	echo "source directory exist" 
else
	echo "source directory doesn't exist, automatically create one at follwoing path:\n  $catkinWS/src"
	mkdir -p  $catkinWS/src
fi

#clone
if ! [ -d $catkinWS/src/thesis ]; then
	git clone --recurse-submodules https://github.com/lentychang/thesis.git $catkinWS/src/thesis
fi
# check if docker is installed
if [ -x "$(command -v docker)" ]; then
        echo "Docker is installed"
else
	echo "Docker not installed or your are not in docker group"
	exit 1
fi

# Download Model
if ! [ -d /tmp/thesis_models.tar.gz ]	
	wget -O /tmp/thesis_models.tar.gz "https://docs.google.com/uc?export=download&id=1hu24fzK6UWyHuMvjTJyuWSYJhqoMSfFP"
else
	sizeOfDownloadFile=$( ls -al | grep thesis_models.tar.gz | awk '{ print $5 }')
     	if [ "$sizeOfDownloadFile" == '85060446' ]; then
		echo "Download success!!"
	else
		echo "Download failed !"
		rm /tmp/thesis_models.tar.gz
		echo "Size not correct, please execute this script again or you can downlaod manually to /tmp/thesis_models.tar.gz with following link:\nhttps://drive.google.com/open?id=1hu24fzK6UWyHuMvjTJyuWSYJhqoMSfFP"
		exit 1
	fi
fi


if ! [ -d $modelDir ]; then
      mkdir -p $modelDir
fi

if ! [ -f /tmp/thesis_models.tar.gz ]; then
	tar -xzvf /tmp/thesis_models.tar.gz -C $modelDir
fi

#[TODO]
# nvidia version is fixed to nvidia-384, change to auto grep on host machine or
# use nvdia-docker?

# build images
echo "Start to build docker images, it might takes more than 20mins..."

cd $catkinWS/src/thesis/bringups
# start build image
bash ./init_build.sh $enable_nvdia

# change the position of modelDir to mount
sed -i "s/- \$HOME\/exchange:\/root\/exchange/- $modelDir\/tempData:\/root\/exchange\/tempData/g" docker-compose.yml
