#!/bin/bash

clear

echo "======================================="
echo "        SKYDO PANEL INSTALLER V6"
echo "              BY SKYDO YT"
echo "======================================="

sleep 2

# COLORS
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}[1/9] Updating package list...${NC}"
apt update -y

echo -e "${GREEN}[2/9] Installing dependencies...${NC}"
apt install -y curl git sudo unzip build-essential ca-certificates gnupg

echo -e "${GREEN}[3/9] Removing old NodeJS...${NC}"
apt remove -y nodejs npm 2>/dev/null
rm -rf /usr/lib/node_modules

echo -e "${GREEN}[4/9] Installing latest NodeJS 20 LTS...${NC}"
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -

apt install -y nodejs

echo -e "${GREEN}[5/9] Checking versions...${NC}"

echo "NODE VERSION:"
node -v

echo "NPM VERSION:"
npm -v

echo -e "${GREEN}[6/9] Installing latest PM2...${NC}"
npm install -g pm2@latest

echo -e "${GREEN}[7/9] Downloading SKYDO PANEL...${NC}"

cd /root || exit

rm -rf SKYDOPANELINSTALLERV3

git clone https://github.com/ggghosain0-ux/SKYDOPANELINSTALLERV3.git

cd SKYDOPANELINSTALLERV3 || exit

echo -e "${GREEN}[8/9] Installing panel dependencies...${NC}"

rm -rf node_modules package-lock.json

npm install --legacy-peer-deps

echo -e "${GREEN}[9/9] Creating environment...${NC}"

cat > .env << EOF
PORT=3000
HOST=0.0.0.0
GEMINI_API_KEY=PUT_YOUR_GEMINI_API_KEY_HERE
EOF

echo -e "${GREEN}Starting SKYDO PANEL...${NC}"

pm2 delete SKYDO-PANEL 2>/dev/null

PORT=3000 HOST=0.0.0.0 pm2 start npm \
--name SKYDO-PANEL \
-- run dev -- --host 0.0.0.0 --port 3000

pm2 save

pm2 startup systemd -u root --hp /root

echo -e "${GREEN}Opening firewall...${NC}"

apt install -y ufw

ufw allow 22/tcp
ufw allow 3000/tcp
ufw --force enable

sleep 5

IP=$(curl -4 -s ifconfig.me)

clear

echo "======================================="
echo "       SKYDO PANEL INSTALLED"
echo "            BY SKYDO YT"
echo "======================================="

echo ""
echo -e "${GREEN}PANEL URL:${NC}"
echo "http://$IP:3000"
echo ""

echo -e "${GREEN}PM2 COMMANDS:${NC}"
echo "pm2 logs SKYDO-PANEL"
echo "pm2 restart SKYDO-PANEL"
echo "pm2 stop SKYDO-PANEL"
echo ""

echo -e "${GREEN}EDIT ENV FILE:${NC}"
echo "nano /root/SKYDOPANELINSTALLERV3/.env"
echo ""

echo -e "${GREEN}CHECK RUNNING PORT:${NC}"
echo "ss -tulpn | grep node"
echo ""

echo "DONE!"
