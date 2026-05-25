#!/bin/bash

# =========================================================
#            SKYDO MC PANEL AUTO HOST INSTALLER
#                 HOST ON LOCALHOST:3005
# =========================================================

clear

echo "=================================================="
echo "           SKYDO MC PANEL INSTALLER"
echo "=================================================="

sleep 2

# Root Check
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Go Root
cd /root || exit

# Update Server
echo "[1/7] Updating server..."
apt update -y && apt upgrade -y

# Install Packages
echo "[2/7] Installing dependencies..."
apt install -y \
git \
curl \
wget \
nano \
sudo \
unzip \
software-properties-common \
ca-certificates \
apt-transport-https \
gnupg

# Install Node.js 20
echo "[3/7] Installing NodeJS..."
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

# Install PM2
echo "[4/7] Installing PM2..."
npm install -g pm2

# Install Docker
echo "[5/7] Installing Docker..."
curl -fsSL https://get.docker.com | sh

systemctl enable docker
systemctl start docker

# Clone Repository
echo "[6/7] Cloning repository..."

rm -rf SKYDOPANELINSTALLERV3

git clone https://github.com/ggghosain0-ux/SKYDOPANELINSTALLERV3

cd SKYDOPANELINSTALLERV3 || exit

# Install Node Modules
echo "[7/7] Installing panel dependencies..."

npm install

# Create Environment File
cat > .env <<EOF
HOST=0.0.0.0
PORT=3005
NODE_ENV=production
EOF

# Stop Old Instance
pm2 delete SKYDOMCPANEL 2>/dev/null

# Start Panel
echo "Starting panel on localhost:3005..."

PORT=3005 pm2 start npm --name "SKYDOMCPANEL" -- start

# Save PM2
pm2 save

# Enable Auto Start
pm2 startup systemd -u root --hp /root

# Done
clear

echo "=================================================="
echo "       SKYDO PANEL INSTALLED SUCCESSFULLY"
echo "=================================================="
echo ""
echo "LOCALHOST URL:"
echo "http://localhost:3005"
echo ""
echo "PUBLIC URL:"
echo "http://YOUR_SERVER_IP:3005"
echo ""
echo "PM2 COMMANDS:"
echo "pm2 status"
echo "pm2 logs SKYDOMCPANEL"
echo "pm2 restart SKYDOMCPANEL"
echo ""
echo "=================================================="
