from centos:7
run yum update -y && yum install koji koji-utils -y && yum clean all && \
    useradd kojiadmin && mkhomedir_helper kojiadmin
run yum install mock setarch rpm-build createrepo -y && yum clean all
