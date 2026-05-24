#!/bin/bash

clear

echo "======================================="
echo "      SKYDO PANEL INSTALLER V3"
echo "            BY SKYDO YT"
echo "======================================="

sleep 2

echo "[1/8] Updating system..."
apt update -y && apt upgrade -y

echo "[2/8] Installing dependencies..."
apt install -y curl git unzip sudo software-properties-common

echo "[3/8] Installing Node.js 20..."
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

echo "[4/8] Installing PM2..."
npm install -g pm2

echo "[5/8] Cloning SKYDO Panel..."
cd /root
rm -rf SKYDOPANELINSTALLERV3

git clone https://github.com/ggghosain0-ux/SKYDOPANELINSTALLERV3.git

cd SKYDOPANELINSTALLERV3

echo "[6/8] Creating environment..."

cat > .env << EOF
GEMINI_API_KEY=PUT_YOUR_GEMINI_API_KEY_HERE
APP_URL=http://localhost:5173
EOF

echo "[7/8] Installing npm packages..."
npm install

echo "[8/8] Building panel..."
npm run build || true

echo "Starting SKYDO PANEL..."

pm2 start npm --name "SKYDO-PANEL" -- run dev

pm2 save

echo "======================================="
echo "      SKYDO PANEL INSTALLED"
echo "            BY SKYDO YT"
echo "======================================="

IP=$(curl -s ifconfig.me)

echo ""
echo "PANEL URL:"
echo "http://$IP:5173"
echo ""
echo "PM2 COMMANDS:"
echo "pm2 logs SKYDO-PANEL"
echo "pm2 restart SKYDO-PANEL"
echo "pm2 stop SKYDO-PANEL"
echo ""
echo "IMPORTANT:"
echo "Edit .env and put your Gemini API key:"
echo "nano /root/SKYDOPANELINSTALLERV3/.env"
echo ""
