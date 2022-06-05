# Ubuntu 16.04 LTS
FROM ubuntu:16.04

# maintainer
MAINTAINER cetusk

# host name
ARG HOST

# supress warning
ENV DEBIAN_FRONTEND noninteractive

# update repogitory
RUN apt update

# install Linux utils
RUN apt install --yes apt-utils
RUN apt install --yes apt-transport-https ca-certificates
RUN apt install --yes vim
RUN apt install --yes less
RUN apt install --yes wget

#--- PBS configuration ---#

# install torque system
RUN apt install --yes torque-server torque-scheduler torque-mom

# create server profile
RUN ["/bin/bash", "-c", "echo \"${HOST}\" > /etc/torque/server_name"]
RUN ["/bin/bash", "-c", "echo \"${HOST} np=4\" > /var/spool/torque/server_priv/nodes"]

# change scheduling configuration
RUN ["/bin/bash", "-c", "cp /var/spool/torque/sched_priv/sched_config /var/spool/torque/sched_priv/sched_config.orig"]
RUN ["/bin/bash", "-c", "sed \"s/help_starving_jobs.*true.*ALL/help_starving_jobs false ALL/\" /var/spool/torque/sched_priv/sched_config.orig > /var/spool/torque/sched_priv/sched_config"]
RUN chmod 777 /var/spool/torque/spool
RUN chmod o+t /var/spool/torque/spool

# change root profile
RUN ["/bin/bash", "-c", "cp /root/.profile /root/.profile.orig"]
RUN ["/bin/bash", "-c", "sed \"s/mesg n || true/#mesg n || true/\" /root/.profile.orig > /root/.profile"]
RUN ["/bin/bash", "-c", "echo \"test -t 0 && mesg n\" >> /root/.profile"]


#--- Anaconda configuration ---#

# download, install and remove Anaconda3 @ 10.15.2019 ver.
RUN ["/bin/bash", "-c", "wget https://repo.continuum.io/archive/Anaconda3-2019.10-Linux-x86_64.sh -O /tmp/Anaconda3-2019.10-Linux-x86_64.sh"]
RUN chmod +x /tmp/Anaconda3-2019.10-Linux-x86_64.sh
RUN ["/bin/bash", "-c", "/tmp/Anaconda3-2019.10-Linux-x86_64.sh -b -p /opt/anaconda3"]
RUN ["/bin/bash", "-c", "rm /tmp/Anaconda3-2019.10-Linux-x86_64.sh"]

# add alias into the ~/.bashrc
RUN ["/bin/bash", "-c", "sed -i \"s@# Alias definitions.@# Alias definitions.\\nalias vi='vim'\\nalias python='\/opt\/anaconda3\/bin\/python3'\\n@\" ~/.bashrc"]


#--- Building configuration ---#

# install build-essential and cmake
RUN apt install --yes build-essential
RUN apt install --yes cmake


#--- MPI configuration ---#

# install OpenMPI: documents, binary, development library
RUN apt install --yes openmpi-doc openmpi-bin libopenmpi-dev


#--- MKL configuration ---#

# download, add and remove GPC-key of repogitory
RUN ["/bin/bash", "-c", "wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB -O /tmp/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB"]
RUN apt-key add /tmp/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB
RUN ["/bin/bash", "-c", "rm /tmp/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB"]

# download and add repogitory
RUN ["/bin/bash", "-c", "wget https://apt.repos.intel.com/setup/intelproducts.list -O /etc/apt/sources.list.d/intelproducts.list"]
RUN apt update

# install latest verion
RUN apt install --yes intel-mkl-64bit-2020.0-088


#--- environmental setteings ---#

# empty line
RUN ["/bin/bash", "-c", "echo \"\" >> ~/.bashrc"]

# hash tag
RUN ["/bin/bash", "-c", "echo \"# exporting environmental variable\" >> ~/.bashrc"]

# lib and ld path
RUN ["/bin/bash", "-c", "echo \"export LIBRARY_PATH=/lib:/usr/lib:/usr/local/lib\" >> ~/.bashrc"]
RUN ["/bin/bash", "-c", "echo \"export LD_LIBRARY_PATH=/lib:/usr/lib:/usr/local/lib\" >> ~/.bashrc"]

# Anaconda3
RUN ["/bin/bash", "-c", "echo \"export PATH=\\$PATH:/opt/anaconda3/bin\" >> ~/.bashrc"]

# MKL
RUN ["/bin/bash", "-c", "echo \"export MKL_ROOT_DIR=/opt/intel/mkl\" >> ~/.bashrc"]
RUN ["/bin/bash", "-c", "echo \"export LIBRARY_PATH=\\$MKL_ROOT_DIR/lib/intel64:\\$LIBRARY_PATH\" >> ~/.bashrc"]
RUN ["/bin/bash", "-c", "echo \"export LD_LIBRARY_PATH=\\$MKL_ROOT_DIR/lib/intel64:/opt/intel/lib/intel64_lin:\\$LD_LIBRARY_PATH\" >> ~/.bashrc"]

# empty line
RUN ["/bin/bash", "-c", "echo \"\" >> ~/.bashrc"]


#--- sample configuration ---#

# make "test" directory
RUN ["/bin/bash", "-c", "mkdir /home/test"]

# copy file for testing
COPY run.sh /home/test/run.sh
COPY test.cpp /home/test/test.cpp

# MPI g++ compile test code
RUN ["/bin/bash", "-c", "mpicxx -o /home/test/test /home/test/test.cpp"]


#--- Starting up configuration ---#

# copy file for starting up
COPY startup.sh /var/startup.sh

# augumentation of entry point
RUN ["/bin/bash", "-c", "sed -i \"s/HOST/${HOST}/g\" /var/startup.sh"]
RUN chmod 744 /var/startup.sh
RUN ["/var/startup.sh", "&&", "tail", "-f", "/dev/null"]
