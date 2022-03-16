FROM ubuntu:latest
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
# Start SSH service
RUN service ssh start
# Expose docker port 22
EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]
