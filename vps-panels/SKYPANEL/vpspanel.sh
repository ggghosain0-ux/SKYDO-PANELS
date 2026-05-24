#!/bin/bash

clear

echo "======================================="
echo "      SKYDO PANEL INSTALLER V4"
echo "            BY SKYDO YT"
echo "======================================="

sleep 2

echo "[1/10] Updating system..."
apt update && apt upgrade -y

echo "[2/10] Installing dependencies..."
apt install -y curl git unzip sudo software-properties-common build-essential nginx ufw

echo "[3/10] Installing Node.js 20 LTS..."
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

echo "[4/10] Checking versions..."
node -v
npm -v

echo "[5/10] Installing PM2..."
npm install -g pm2

echo "[6/10] Cloning SKYDO Panel..."
cd /root || exit

rm -rf SKYDOPANELINSTALLERV3

git clone https://github.com/ggghosain0-ux/SKYDOPANELINSTALLERV3.git

cd SKYDOPANELINSTALLERV3 || exit

echo "[7/10] Creating .env file..."

cat > .env << EOF
GEMINI_API_KEY=PUT_YOUR_GEMINI_API_KEY_HERE
PORT=5173
HOST=0.0.0.0
EOF

echo "[8/10] Installing npm packages..."
npm install

echo "[9/10] Building panel..."
npm run build

echo "[10/10] Starting panel with PM2..."

pm2 delete SKYDO-PANEL 2>/dev/null

pm2 start "npm run preview -- --host 0.0.0.0 --port 5173" --name SKYDO-PANEL

pm2 save
pm2 startup systemd -u root --hp /root

echo "Opening firewall port..."
ufw allow 5173/tcp
ufw allow 22/tcp
ufw --force enable

IP=$(curl -4 -s ifconfig.me)

clear

echo "======================================="
echo "      SKYDO PANEL INSTALLED"
echo "            BY SKYDO YT"
echo "======================================="

echo ""
echo "PANEL URL:"
echo "http://$IP:5173"
echo ""
echo "PM2 COMMANDS:"
echo "pm2 logs SKYDO-PANEL"
echo "pm2 restart SKYDO-PANEL"
echo "pm2 stop SKYDO-PANEL"
echo ""
echo "EDIT ENV FILE:"
echo "nano /root/SKYDOPANELINSTALLERV3/.env"
echo ""
echo "Done!"
