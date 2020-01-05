# Hadoop shell-scripts-for-dev-env

>The process of building a Hadoop development environment based on the DRY principle will be automated in stages.
>
>The ultimate purpose of creating shell scripts is to phase the development environment into a docker container.
>
>However, considering YAGNI, I will start with hard-coded script and increase the level of abstraction whenever various requirements arise.



## main tasks

* user creation and authorization
  - [ ] [useradd](https://stackoverflow.com/questions/27701930/add-user-to-docker-container)
* mapping hosts with IP addresses 
* network configuration
  - [ ] sed
* sshd configuration 
  * [ ] [ssh-keyscan](https://serverfault.com/questions/132970/can-i-automatically-add-a-new-host-to-known-hosts/132973)
* installation of jdk-1.8.0 and hadoop-2.7.7 & set PATH
  - [ ] [/etc/pam.d/](http://www.linux-pam.org/Linux-PAM-html/sag-configuration-file.html), [switching user without password](https://unix.stackexchange.com/questions/113754/allow-user1-to-su-user2-without-password)
* copying pre-compiled native library into hadoop
* copying pre-scripted hadoop configuration files



### shell scripts / user-creation.sh

```bash
# user creation

useradd hadoop
usermod --password $(openssl passwd -1 {password}) {username}
sed -i '/root\s.*ALL=(ALL)\s.*ALL/a hadoop  ALL=(ALL)       ALL' /etc/sudoers
sed -i "s/quiet/quiet vga=791/" /boot/grub/grub.conf
```



###   shell scripts / host-confs.sh

```bash
# change hostname

sed -i '/s/HOSTNAME=oldname/HOSTNAME=newname' /etc/sysconfig/network

# ifup 
HWaddr=$(ifconfig -a | awk '/eth1/ {print $5;}')
(cd /etc/sysconfig/network-scripts && touch ifcfg-eth1)
echo DEVICE=eth1 >> /etc/sysconfig/network-scripts/ifcfg-eth1
echo BOOTPROTO=none >> /etc/sysconfig/network-scripts/ifcfg-eth1
echo TYPE=Ethernet >> /etc/sysconfig/network-scripts/ifcfg-eth1
echo NM_CONTROLLED=no >> /etc/sysconfig/network-scripts/ifcfg-eth1
echo ONBOOT=yes >> /etc/sysconfig/network-scripts/ifcfg-eth1
echo PEERDNS=no >> /etc/sysconfig/network-scripts/ifcfg-eth1
echo HWaddr=$HWadrr >> /etc/sysconfig/network-scripts
echo IPADDR=192.168.56.104 >> /etc/sysconfig/network-scripts/ifcfg-eth1
echo NETMASK=255.255.255.0 >> /etc/sysconfig/network-scripts/ifcfg-eth1
echo GATEWAY=0.0.0.0 >> /etc/sysconfig/network-scripts/ifcfg-eth1
echo IPV6INIT=no >> /etc/sysconfig/network-scripts/ifcfg-eth1
echo USERCTL=no >> /etc/sysconfig/network-scripts/ifcfg-eth1

set -i 's/ONBOOT=no/ONBOOT=yes/' /etc/sysconfig/network-scripts/ifcfg-eth0

sudo ifup eth0 
sudo ifup eth1

# map host ips

echo "192.168.56.101 hadoop1" >> /etc/hosts
echo "192.168.56.102 hadoop2" >> /etc/hosts
echo "192.168.56.103 hadoop3" >> /etc/hosts
echo "192.168.56.104 hadoop4" >> /etc/hosts
```



### shell scripts / sshd-confs.sh

``` bash
# sshpass installation

sudo yum install -y gcc 
gzip -d sshpass-1.05.tar.gz
tar -xvf sshpass-1.05.tar
chown -R root:root sshpass-1.05
(cd sshpass-1.05 && ./configure && make install && rm -rf sshpass-1.05  sshpass-1.05.tar)

# ssh authorization

ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa
ssh-keyscan -t rsa hadoop2 >> ~/.ssh/known_hosts
sshpass -f passwd.txt ssh-copy-id hadoop@hadoop2
```

 

### shell scripts / install-dependencies.sh

``` bash
# JDK 1.8.0
if [[ ! -f jdk-8u231-linux-x64.rpm ]]
then
        rpm -Uvh jdk-8u231-linux-x64.rpm
        echo "export JAVA_HOME=/usr/java/default" >> /home/hadoop/.bashrc
else
        echo "JDK package file does not exist"
fi

# HADOOP-2.7.7
gzip -d hadoop-2.7.7.tar.gz
tar -xvf hadoop-2.7.7.tar

if [[ ! -d hadoop-2.7.7 ]]
then
        mv hadoop-2.7.7 /usr/local
        (cd /usr/local && ln -s hadoop-2.7.7 hadoop)
        echo "export HADOOP_HOME=/usr/local/hadoop" >> /home/hadoop/.bashrc
else
		echo "hadoop folder does not exists"
fi

echo "PATH=$PATH:${JAVA_HOME}/bin:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin" >> /home/hadoop/.bashrc
echo "export PATH" >> /home/hadoop/.bashrc
```



### shell scripts / hadoop-configs.sh

``` bash
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
```



**_documented by sana-lucet_**