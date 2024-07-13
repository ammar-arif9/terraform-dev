#!/bin/bash
# Create a new user
useradd -m -s /bin/bash admin
echo "admin:password" | chpasswd

# Grant sudo privileges
usermod -aG wheel admin

# Allow passwordless sudo
echo "admin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Enable password authentication and restart SSH service
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd

dnf upgrade -y && dnf update -y
