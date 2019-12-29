#!/bin/bash

SOURCE=$HOME/$1
TARGET=$HADOOP_HOME/etc/hadoop
FILE_LIST=(core-site.xml hadoop-env.sh hdfs-site.xml slaves yarn-env.sh yarn-site.xml)

if [[ -z "$1" ]] 
then 
	echo "no SOURCE has been set" 
	exit 1
else
	#delete original files
	for i in "${FILE_LIST[@]}"; do rm "$TARGET/$i"; done;
	rm $HADOOP_HOME/libexec/hadoop-config.sh

	#copy new files
	for i in "${FILE_LIST[@]}"; do cp "$SOURCE/$i" "$TARGET"; done;
	cp "$SOURCE/hadoop-config.sh" $HADOOP_HOME/libexec
fi
echo "$SOURCE/hadoop-config.sh"

echo "done!"






