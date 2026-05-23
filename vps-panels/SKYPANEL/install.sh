#!/bin/bash

clear

echo "======================================"
echo "       SKYDI PANEL INSTALLER"
echo "          MADE BY SKYDO"
echo "======================================"

sleep 2

echo ""
echo "[1/8] Updating VPS..."
apt update -y && apt upgrade -y

echo ""
echo "[2/8] Installing required packages..."
apt install -y curl git unzip software-properties-common

echo ""
echo "[3/8] Installing Node.js 20..."
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

echo ""
echo "[4/8] Installing PM2..."
npm install -g pm2

echo ""
echo "[5/8] Cloning SKYDI Panel..."
cd /root || exit
rm -rf SKYDIVPSPANELV2
git clone https://github.com/ggghosain0-ux/SKYDIVPSPANELV2.git

echo ""
echo "[6/8] Installing dependencies..."
cd SKYDIVPSPANELV2 || exit
npm install

echo ""
echo "[7/8] Opening firewall port 3005..."
ufw allow 3005/tcp || true

echo ""
echo "[8/8] Starting SKYDI Panel..."
pm2 start npm --name "SKYDI-PANEL" -- start

pm2 save
pm2 startup

IP=$(curl -s ifconfig.me)

clear

echo "======================================"
echo "       SKYDI PANEL INSTALLED"
echo "======================================"
echo ""
echo " PANEL URL:"
echo " http://$IP:3005"
echo ""
echo " PM2 NAME: SKYDI-PANEL"
echo ""
echo "======================================"
echo "          MADE BY SKYDO"
echo "======================================"
