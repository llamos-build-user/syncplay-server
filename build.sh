#!/bin/bash

if [ $# -eq 0 ]
then
	echo "Please provide a version number."
	echo "$0 <SYNCPLAY_VERSION> [latest] [push]"
	exit
fi

docker build -t llamos/syncplay-server:$1 --build-arg SYNCPLAY_VERSION=$1 .

if [ $# -gt 1 ]
then
	if [ $2 == "latest" ]
	then
		docker tag llamos/syncplay-server:1.6.4a llamos/syncplay-server:latest
	fi
fi

if [ $# -gt 2 ]
then
	if [ $3 == "push" ]
	then
		docker push llamos/syncplay-server:$1
		if [ $2 == "latest" ]
		then
			docker push llamos/syncplay-server:latest
		fi
	fi
fi
