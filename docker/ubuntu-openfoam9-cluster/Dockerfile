FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

#install essentials
RUN apt-get update \
    && apt-get install -y \
    ssh \
    sudo \
    ffmpeg \
    wget \
    nano \
    build-essential \
    software-properties-common ;\
    rm -rf /var/lib/apt/lists/*

#install python
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#install python packages
RUN pip3 install numpy

#download openfoam v9
# the script from https://github.com/jakobhaervig/openfoam-dockerfiles
RUN wget -O - http://dl.openfoam.org/gpg.key | apt-key add - ;\
    add-apt-repository http://dl.openfoam.org/ubuntu ;\
    apt-get update ;\
    apt-get install -y openfoam9 paraviewopenfoam56- ;\
    rm -rf /var/lib/apt/lists/*


RUN apt update && apt install  openssh-server sudo -y && apt install nano sudo -y


# Create a user “sshuser” and group “sshgroup”
RUN groupadd sshgroup && useradd -ms /bin/bash -g sshgroup sshuser  
RUN echo "sshuser:123" | chpasswd

# Create sshuser directory in home
RUN mkdir -p /home/sshuser/.ssh

# Copy the ssh public key in the authorized_keys file. The idkey.pub below is a public key file you get from ssh-keygen. They are under ~/.ssh directory by default.
COPY idkey.pub /home/sshuser/.ssh/authorized_keys
COPY sshd_config /etc/ssh/ssh_config

# change ownership of the key file. 
RUN chown sshuser:sshgroup /home/sshuser/.ssh/authorized_keys && chmod 600 /home/sshuser/.ssh/authorized_keys

#source openfoam and fix docker mpi
RUN	echo "source /opt/openfoam9/etc/bashrc" >> ~sshuser/.bashrc ;\
    echo "export OMPI_MCA_btl_vader_single_copy_mechanism=none" >> ~sshuser/.bashrc



#change environmental variables to make sure $WM_PROJECT_USER_DIR is outside of the container
RUN sudo sed -i 's+export WM_PROJECT_USER_DIR="$HOME/$WM_PROJECT/$USER-$WM_PROJECT_VERSION"+export WM_PROJECT_USER_DIR="/data/$WM_PROJECT/foam-$WM_PROJECT_VERSION"+g' /opt/openfoam9/etc/bashrc



# Start SSH service
RUN service ssh start

# Expose docker port 22
EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]
