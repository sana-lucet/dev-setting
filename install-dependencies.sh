#!/bin/bash
#if [[ (-f jdk-8u231-linux-x64.rpm) && (-d "hadoop-2.7.7") ]]
if [[ (-f jdk-8u231-linux-x64.rpm) ]]
then 
	#rpm -Uvh jdk-8u231-linux-x64.rpm
	#mv hadoop-2.7.7 /usr/local
	#(cd /usr/local && ln -s hadoop-2.7.7 hadoop)
	
	echo "export JAVA_HOME=/usr/java/default" >> $HOME/.bashrc
	echo "export HADOOP_HOME=/usr/local/hadoop" >> $HOME/.bashrc
	echo "PATH=$PATH:${JAVA_HOME}/bin:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin" >> $HOME/.bashrc
	echo "export PATH " >> $HOME/.bashrc
else
	echo "file does not exist"
fi
