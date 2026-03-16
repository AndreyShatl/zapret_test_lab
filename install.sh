#!/bin/bash
set -e

echo "[+] Zapret one-click installer"

# --- checks ---
if [ "$(id -u)" -ne 0 ]; then
  echo "Run as root"
  exit 1
fi

# --- deps ---
echo "[+] Installing dependencies..."
apt update
apt install -y nftables curl ca-certificates

# --- zapret dirs ---
echo "[+] Preparing /etc/zapret..."
mkdir -p /etc/zapret
mkdir -p /etc/nftables.d

# --- copy configs ---
echo "[+] Installing zapret configs..."
cp ./config/zapret/yt-tcp.conf /etc/zapret/yt-tcp.conf
cp ./config/zapret/youtube.txt /etc/zapret/youtube.txt

# --- nftables ---
echo "[+] Installing nftables rules..."
cp ./config/nftables/zapret.nft /etc/nftables.d/zapret.nft

if ! grep -q "zapret.nft" /etc/nftables.conf 2>/dev/null; then
  echo "include \"/etc/nftables.d/zapret.nft\"" >> /etc/nftables.conf
fi

nft -f /etc/nftables.conf

# --- zapret service ---
echo "[+] Enabling zapret yt-tcp service..."
systemctl enable zapret-nfqws@yt-tcp
systemctl restart zapret-nfqws@yt-tcp

echo
echo "[✓] DONE"
echo "Check status:"
echo "  systemctl status zapret-nfqws@yt-tcp"
echo "  nft list table inet zapret"
