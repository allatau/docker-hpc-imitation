FROM centos:7

RUN yum -y update 
RUN yum install -y initscripts 
RUN yum install -y openssh 
RUN yum install -y openssh-server
RUN yum install -y openssh-clients
RUN yum install -y sudo 
RUN yum install -y passwd
RUN yum install -y sed screen tmux byobu which vim-enhanced
RUN sshd-keygen
RUN sed -i 's/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g' /etc/ssh/sshd_config && sed -i 's/UsePAM.*/UsePAM no/g' /etc/ssh/sshd_config

# setup default user
RUN useradd admin -G wheel -s /bin/bash -m
RUN echo 'admin:admin' | chpasswd
RUN echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

# update root passwd
RUN echo 'root:root' | chpasswd

# expose ports for ssh
EXPOSE 22

RUN yum install -y gcc make rpm-build libtool hwloc-devel libX11-devel libXt-devel libedit-devel libical-devel ncurses-devel perl postgresql-devel python-devel tcl-devel  tk-devel swig expat-devel openssl-devel libXext libXft
# install dependiencies for running
RUN yum install -y expat libedit postgresql-server python sendmail sudo tcl tk libical
# useful tools
RUN yum install -y git epel-release which net-tools
# install pip after epel
RUN yum install -y python-pip
# get latest pbspro code
WORKDIR /src
RUN git clone https://github.com/pbspro/pbspro.git
WORKDIR /src/pbspro
# build
RUN ./autogen.sh
RUN ./configure -prefix=/opt/pbs
RUN make
RUN make dist
# directories for rpm build must be ~/rpmbuild
RUN mkdir /root/rpmbuild
RUN mkdir /root/rpmbuild/SOURCES
RUN mkdir /root/rpmbuild/SPECS
RUN cp pbspro-*.tar.gz /root/rpmbuild/SOURCES
RUN cp pbspro.spec /root/rpmbuild/SPECS
# build rpms
WORKDIR /root/rpmbuild/SPECS
RUN rpmbuild -ba pbspro.spec
# install pbspro
WORKDIR /root/rpmbuild/RPMS/x86_64
RUN yum install -y pbspro-server-*.rpm
# cd to root dir
WORKDIR /

CMD    ["/usr/sbin/sshd", "-D"]