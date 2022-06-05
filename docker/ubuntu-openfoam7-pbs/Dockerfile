# Ubuntu 16.04 LTS
FROM cetusk/pbs-ubuntu16.04:0.2

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y \
    wget \
    sudo \
    gnupg \
    software-properties-common

# Create new user
RUN useradd --user-group --create-home --shell /bin/bash cfd ;\
    echo "cfd ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Add repo for OpenFoam
RUN wget -O - http://dl.openfoam.org/gpg.key | apt-key add - ;\
    add-apt-repository http://dl.openfoam.org/ubuntu ;\
    apt-get update ;

RUN apt-get install -y openfoam7


# Create a user “sshuser” and group “sshgroup”
RUN groupadd sshgroup && useradd -ms /bin/bash -g sshgroup sshuser  
RUN echo "sshuser:123" | chpasswd


RUN echo "source /opt/openfoam7/etc/bashrc" >> /home/sshuser/.bashrc

RUN apt update && apt install  openssh-server sudo -y && apt install nano sudo -y

# Create sshuser directory in home
RUN mkdir -p /home/sshuser/.ssh

# Copy the ssh public key in the authorized_keys file. The idkey.pub below is a public key file you get from ssh-keygen. They are under ~/.ssh directory by default.
COPY idkey.pub /home/sshuser/.ssh/authorized_keys
COPY sshd_config /etc/ssh/ssh_config

# change ownership of the key file. 
RUN chown sshuser:sshgroup /home/sshuser/.ssh/authorized_keys && chmod 600 /home/sshuser/.ssh/authorized_keys

# Start SSH service
RUN service ssh start

# Expose docker port 22
EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]
