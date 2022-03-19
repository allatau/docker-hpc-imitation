# FROM centos:7
FROM pbspro/pbspro:centos7

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
RUN sed -i 's/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g' /etc/ssh/sshd_config

# setup default user
RUN useradd admin -G wheel -s /bin/bash -m
RUN echo 'admin:admin' | chpasswd
RUN echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

# update root passwd
RUN echo 'root:root' | chpasswd

# expose ports for ssh
EXPOSE 22

CMD    ["/usr/sbin/sshd", "-D"]