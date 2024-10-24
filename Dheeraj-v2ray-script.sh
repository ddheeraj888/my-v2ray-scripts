#!/bin/bash
# V2Ray Setup Script

# Update system packages
apt-get update -y
apt-get upgrade -y

# Install dependencies
apt-get install -y curl unzip

# Install V2Ray
bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)

# Generate V2Ray configuration
UUID=$(cat /proc/sys/kernel/random/uuid)
cat <<EOF > /usr/local/etc/v2ray/config.json
{
  "inbounds": [{
    "port": 1080,
    "protocol": "vmess",
    "settings": {
      "clients": [{
        "id": "$UUID",
        "alterId": 64
      }]
    },
    "streamSettings": {
      "network": "ws",
      "wsSettings": {
        "path": "/v2ray"
      }
    }
  }],
  "outbounds": [{
    "protocol": "freedom",
    "settings": {}
  }]
}
EOF

# Enable and start V2Ray
systemctl enable v2ray
systemctl restart v2ray

# Output V2Ray details
echo "V2Ray setup complete!"
echo "UUID: $UUID"
echo "WebSocket Path: /v2ray"
echo "Port: 1080"
