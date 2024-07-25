#!/bin/bash

# Update the system
dnf update -y

# Install EPEL repository
dnf install epel-release -y

# Install Ansible
dnf install ansible -y

#!/bin/bash

# Update the package list
sudo dnf update -y

# Install dependencies
sudo dnf install -y unzip curl

# Set the desired version of Vault
VAULT_VERSION="1.14.0" # Change to the desired version
VAULT_ARCH="linux_amd64"

# Download Vault
curl -Lo vault.zip https://releases.hashicorp.com/vault/$VAULT_VERSION/vault_${VAULT_VERSION}_${VAULT_ARCH}.zip

# Unzip the downloaded file
unzip vault.zip

# Move the Vault binary to /usr/local/bin
sudo mv vault /usr/local/bin/

# Give it executable permissions
sudo chmod +x /usr/local/bin/vault

# Verify the installation
vault version

# Create a directory for Vault configuration
sudo mkdir -p /etc/vault.d

# Create a basic configuration file
cat <<EOF | sudo tee /etc/vault.d/vault.hcl
storage "file" {
  path = "/opt/vault/data"
}

listener "tcp" {
  address = "127.0.0.1:8200"
  tls_disable = 1
}

api_addr = "http://127.0.0.1:8200"
EOF

# Create the data directory
sudo mkdir -p /opt/vault/data

# Change ownership of the directory
sudo chown -R $(whoami):$(whoami) /opt/vault

# Create a systemd service for Vault
cat <<EOF | sudo tee /etc/systemd/system/vault.service
[Unit]
Description=HashiCorp Vault
Requires=network-online.target
After=network-online.target

[Service]
ExecStart=/usr/local/bin/vault server -config=/etc/vault.d/vault.hcl
User=$(whoami)
Group=$(whoami)
Restart=on-failure
Environment="VAULT_ADDR=http://127.0.0.1:8200"

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to recognize the new service
sudo systemctl daemon-reload

# Start and enable Vault
sudo systemctl start vault
sudo systemctl enable vault

echo "HashiCorp Vault has been installed and started."

hostnamectl set-hostname "ansible-control-node"