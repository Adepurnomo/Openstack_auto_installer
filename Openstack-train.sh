#!/bin/bash
##
clear
if [[ $EUID -ne 0 ]]; then
   echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
   echo "            Please run this scripts on SU !               "
   echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
   exit 1
fi

echo "                                       README"
echo "-----------------------------------------------------------------------------"
echo " Please wait for procces <Testing if puppet apply is finished>               "
echo " if you cancel this ^ procces, login from dashboard http://yourip/dashboard  "
echo " using account admin & pass --> arumi2507                                    "
echo "-----------------------------------------------------------------------------"
sleep 20 >> /dev/null 2>&1
echo " wait... "
echo "---------"
tuned-adm profile throughput-performance

echo "|Update & configure your instance (take several minute.."
sleep 1
systemctl stop firewalld >> /dev/null 2>&1
systemctl disable firewalld >> /dev/null 2>&1
systemctl stop NetworkManager >> /dev/null 2>&1
systemctl disable NetworkManager >> /dev/null 2>&1
sed -i 's/enforcing/disabled/g' /etc/selinux/config
yum install centos-release-openstack-train -y >> /dev/null 2>&1
yum install openstack-packstack -y >> /dev/null 2>&1

setenforce 0 
getenforce 
packstack --gen-answer-file=/root/answer.txt
sed -i 's/CONFIG_NTP_SERVERS=/CONFIG_NTP_SERVERS=0.pool.ntp.org/' /root/answer.txt
sed -i 's/CONFIG_KEYSTONE_ADMIN_PW=*/#CONFIG_KEYSTONE_ADMIN_PW=*/' /root/answer.txt
sed -i 's/CONFIG_MARIADB_PW=*/#CONFIG_MARIADB_PW=*/g' /root/answer.txt
sed -i 's/ONFIG_SWIFT_STORAGE_FSTYPE=ext4/ONFIG_SWIFT_STORAGE_FSTYPE=xfs/' /root/answer.txt
sed -i 's/CONFIG_PROVISION_DEMO=y/CONFIG_PROVISION_DEMO=n/g' /root/answer.txt
sed -i 's/CONFIG_NEUTRON_ML2_MECHANISM_DRIVERS=ovn/CONFIG_NEUTRON_ML2_MECHANISM_DRIVERS=openvswitch/' /root/answer.txt
sed -i 's/CONFIG_NEUTRON_L2_AGENT=ovn/CONFIG_NEUTRON_L2_AGENT=openvswitch/' /root/answer.txt
cat <<EOF>> /root/answer.txt
CONFIG_KEYSTONE_ADMIN_PW=arumi2507
CONFIG_MARIADB_PW=arumi2507
EOF

echo "----------------------------------"
echo "        enable ssh 4 root         "
echo "----------------------------------"
echo "."
sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
#echo "arumi2507" | passwd --stdin root
systemctl restart sshd
sleep 3
#echo "."
packstack --answer-file /root/answer.txt

#echo "----------------------------------"
#echo "       disable ssh 4 root         "
#echo "----------------------------------"
echo "."
#sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
#sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
#systemctl restart sshd

sleep 3
echo "-----------------------------------------------------------------------------------------------------------"
echo "                                      user: admin | password: arumi2507                                    "
echo "-----------------------------------------------------------------------------------------------------------"
echo "."
echo " ----------------------------------------------------------------------------------------------------------"
echo " For your testing on GCP or AWS, put your external ip to /etc/httpd/conf.d/15-horizon* search 'ServerAlias'" 
echo "              and vnc /etc/nova/nova.conf search 'http://generateip:6080' & place your external ip         "
echo "                don't forget, enable nested virtualization on your vm instance AWS or GCP                  "
echo " ----------------------------------------------------------------------------------------------------------"
