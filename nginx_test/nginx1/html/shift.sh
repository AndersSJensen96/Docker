#!/bin/bash

CURRENT_DIR="newest"

COUNT=$(find -type l -ls | grep "newest" | wc -l)

echo "current dir: $CURRENT_DIR"

echo "count: $COUNT"


#Check if symlink points to newest or oldest
if [ $COUNT -gt 0 ]; then

	CURRENT_DIR="oldest"

	echo "Shifting to $CURRENT_DIR" 
fi

#Deleting current symlinks
find -type l -ls -delete


#Create new symlinks
ln -s ./$CURRENT_DIR/* .
