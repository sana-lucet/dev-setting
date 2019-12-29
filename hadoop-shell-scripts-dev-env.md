# Hadoop shell-scripts-for-dev-env

>According to the DRY principle, the process of building a Hadoop development environment is to be automated gradually.
>
>The more terminal works are converted to shell script, the easier it will be to move the development environment to a docker container.



## main tasks

* user creation
  - [ ] [useradd](https://stackoverflow.com/questions/27701930/add-user-to-docker-container)
* copying pre-scripted network configuration and sshd configuration 
  * [ ] [ssh-keyscan](https://serverfault.com/questions/132970/can-i-automatically-add-a-new-host-to-known-hosts/132973)
* installation of jdk-1.8.0 and hadoop-2.7.7 & set PATH
  - [ ] [/etc/pam.d/](http://www.linux-pam.org/Linux-PAM-html/sag-configuration-file.html), [switching user without password](https://unix.stackexchange.com/questions/113754/allow-user1-to-su-user2-without-password)
* copying pre-compiled native library into hadoop
* copying pre-scripted hadoop configuration files



##### shell scripts / user-creation.sh

```bash
# user creation

$ useradd

```



##### shell scripts / install-dependencies.sh

``` bash
# copying pre-compiled native library into hadoop


$

# copying pre-scripted hadoop configuration files

$

```



##### shell scripts / configure-network

``` bash
# network configuration

$ ssh-keygen


```



```
# installation of jdk-1.8.0 and hadoop

$

# set PATH

$



```





