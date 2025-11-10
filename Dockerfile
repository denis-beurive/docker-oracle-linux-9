FROM oraclelinux:9
LABEL authors="Denis BEURIVE"

# Update the system.
USER root
RUN (dnf -y upgrade)

# Create a user.
USER root
RUN (useradd dev)
RUN (sed -i 's/^password[[:space:]]\+requisite[[:space:]]\+pam_pwquality.so[[:space:]]\+.*$/password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 minlen=1 dcredit=0 ucredit=0 lcredit=0 ocredit=0/' /etc/pam.d/system-auth)
RUN (echo -e "dev" | passwd --stdin dev)
RUN (usermod -aG wheel dev)

# Install the development tools.
USER root
RUN (dnf groupinstall "Development Tools" -y)

# Install libraries.
RUN (dnf -y install openssl-devel)

# Install useful utlities.
RUN (dnf -y install mlocate dos2unix tree openssl zip unzip jq wget sudo)

# -----------------------------------------------------------------
# Configure SSH
# -----------------------------------------------------------------

USER root
COPY install_ssh_keys.sh /tmp/install_ssh_keys.sh
RUN (dos2unix /tmp/install_ssh_keys.sh)
RUN (chmod a+wxr /tmp/install_ssh_keys.sh)
RUN (chown dev:root /tmp/install_ssh_keys.sh)
USER dev
RUN (if [ -f /tmp/install_ssh_keys.sh ]; then echo "file exists"; else echo "failure!"; fi)
RUN (if [ -x /tmp/install_ssh_keys.sh ]; then echo "file can be executed"; else echo "failure!"; fi)
RUN (/usr/bin/bash /tmp/install_ssh_keys.sh)
USER root
RUN (if [ -f /tmp/install_ssh_keys.sh ]; then echo "file exists"; else echo "failure!"; fi)
RUN (if [ -x /tmp/install_ssh_keys.sh ]; then echo "file can be executed"; else echo "failure!"; fi)
RUN (/usr/bin/bash /tmp/install_ssh_keys.sh)

WORKDIR /etc/ssh
RUN (sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/' sshd_config)

# -----------------------------------------------------------------
# Set root password
# -----------------------------------------------------------------

USER root
RUN dnf install -y passwd && dnf clean all
RUN echo "root:root" | chpasswd

# -----------------------------------------------------------------
# Update tools and environments.
# -----------------------------------------------------------------

USER root
RUN (updatedb)

# -----------------------------------------------------------------
# Configure the SSH daemon.
# -----------------------------------------------------------------

USER root
WORKDIR /etc/ssh
RUN (sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/' sshd_config)
RUN (sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' sshd_config)
RUN (sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' sshd_config)

# Create a host key (mandatory)
RUN (ssh-keygen -A)

# -----------------------------------------------------------------
# Configure boot
# -----------------------------------------------------------------

USER root
COPY entrypoint.sh /entrypoint.sh
RUN (dos2unix /entrypoint.sh)
RUN (chmod +x /entrypoint.sh)

# -----------------------------------------------------------------
# Start the SSH daemon.
# -----------------------------------------------------------------

STOPSIGNAL SIGTERM
CMD ["/usr/sbin/sshd", "-D"]
ENTRYPOINT ["/entrypoint.sh"]


