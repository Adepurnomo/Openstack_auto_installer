yum update -y
systemctl disable NetworkManager
systemctl disable firewalld
systemctl stop NetworkManager
systemctl stop firewalld
seteforce 0
getenforce
sed -i 's/enforcing/disabled/g' /etc/sysconfig/selinux
yum install centos-release-openstack-train openstack-packstack -y
packstack  --gen-answer-file/root/answer.txt
sed -i 's/CONFIG_NTP_SERVERS=/CONFIG_NTP_SERVERS=0.pool.ntp.org/g' /root/answer.txt
sed -i 's/CONFIG_KEYSTONE_ADMIN_PW=*/#CONFIG_KEYSTONE_ADMIN_PW=*/g' /root/answer.txt
sed -i 's/CONFIG_MARIADB_PW=*/#CONFIG_MARIADB_PW=*/g' /root/answer.txt
sed -i 's/ONFIG_SWIFT_STORAGE_FSTYPE=ext4/ONFIG_SWIFT_STORAGE_FSTYPE=xfs/g' /root/answer.txt
sed -i 's/CONFIG_PROVISION_DEMO=y/CONFIG_PROVISION_DEMO=n/g' /root/answer.txt
sed -i 's/CONFIG_NEUTRON_ML2_MECHANISM_DRIVERS=ovn/CONFIG_NEUTRON_ML2_MECHANISM_DRIVERS=openvswitch/g' /root/answer.txt
sed -i 's/CONFIG_NEUTRON_L2_AGENT=ovn/CONFIG_NEUTRON_L2_AGENT=openvswitch/g' /root/answer.txt
cat <<EOF>> /root/answer.txt
CONFIG_KEYSTONE_ADMIN_PW=arumi2507
CONFIG_MARIADB_PW=arumi2507
EOF
packstack --answer-file/root/answer.txt
echo "--------------------"
echo " password arumi2507 "
echo "--------------------"
