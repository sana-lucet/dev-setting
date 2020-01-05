# Hadoop dockerized-dev-env

> So far, I have covered the method of constructing the Hadoop development environment into Shell Scripts. 
>
> Now, by replacing the shell script one by one with a docker file command, the entire development environment will be moved to a docker container.



## rules for translation

| shell script                          | dockerfile                 |
| ------------------------------------- | -------------------------- |
| $ [run command]                       | RUN [run command]          |
| export $[variable]=[path]             | ENV [variable] [path]      |
| ftp > get > cp [srcPath] [targetPath] | ADD [srcPath] [targetPath] |
| su [username]                         | USER [username]            |
| cd [direct path]                      | WORKDIR [direct path]      |



## dockerfile

>



``` dock
FROM Centos:6.9

MAINTAINER sanalucet sanalucet@gmail.com

USER root

RUN useradd hadoop
RUN usermod --password $(openssl passwd -1 {password}) {username}

RUN sed -i '/root\s.*ALL=(ALL)\s.*ALL/a hadoop  ALL=(ALL)       ALL' /etc/sudoers
RUN sed -i "s/quiet/quiet vga=791/" /boot/grub/grub.conf

RUN yum install -y gcc
ADD /git/sshpass-1.05
RUN chown -R root:root sshpass-1.05 
RUN (cd sshpass-1.05 && ./configure && make install && rm -rf sshpass-1.05)

RUN ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa
RUN ssh-keyscan -t rsa hadoop2 >> ~/.ssh/known_hosts
sshpass -f passwd.txt ssh-copy-id hadoop@hadoop2



```

