#!/bin/bash
#This is for RHEL 7.2, that cannot use yum tool. Modify freely if not RHEL 7.2
#given is 163 source.

echo "Environment checking..."
jud1=`whoami`
if [ $jud1 != "root" ]
then
  echo "Please use it with root user"
  exit 1
else
  echo "User: root    Check done"
fi

ping www.baidu.com -c 2 > /dev/null 2>&1
if [ $? -ne 0 ]
then 
  echo "Please check your net connect"
  exit 2
else
  echo "Net: OK    Check done"
fi
echo "Environment check done"

#rmove OS yum tool,which we cannot use
rpm -qa | grep "yum"
if [ $? -eq 0 ]
then
  rpm -qa | grep yum | xargs rpm -e --nodeps
  rpm -qa | grep yum
  if [ $? -eq 0 ]
  then
    echo "fail to rmove yum, do it manualy."
    exit 3
  fi
fi

#install CentOS yum tool
rpm -ivh ./rpm_package/yum-*.rpm
if [ $? -ne 0 ]
then
  echo "fail to install yum."
  exit 4
fi

#create CentOS .repo file
cp -r /etc/yum.repos.d /etc/yum.repos.d.bak
rm -rf /etc/yum.repos.d/*.repo
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.163.com/.help/CentOS7-Base-163.repo

# make cache
yum clean all
yum makecache


