# Installing AdGuard with LetsEncrypt Certificate

First things first

```bash
apt update && apt upgrade -y
apt install -y certbot python3-certbot-dns-cloudflare apache2-utils neovim bat
```

## Install AdGuard

```bash
apt update && apt upgrade -y
wget https://static.adguard.com/adguardhome/release/AdGuardHome_linux_amd64.tar.gz
sudo tar xvf AdGuardHome_linux_amd64.tar.gz
cd AdGuardHome
sudo ./AdGuardHome -s install
```

## Issue LE Certificate use dns01 challenge with CloudFlare

special thanks to the amazing tutorial from [that ops guy](https://blog.thatopsguy.com/2021/08/lets-encrypt-cert-for-adguard-home/). Just summarized up for my own purposes:

```bash
mkdir /root/.secrets/ && touch /root/.secrets/cloudflare.ini
chmod 0700 /root/.secrets/
chmod 0600 /root/.secrets/cloudflare.ini

cat << EOF > /root/.secrets/cloudflare.ini 
dns_cloudflare_email = youremail@example.com
dns_cloudflare_api_key = yourapikey
EOF

vim /root/.secrets/cloudflare.ini
sudo certbot certonly --dns-cloudflare --dns-cloudflare-credentials /root/.secrets/cloudflare.ini -d hole.elbschloss.xyz --preferred-challenges dns-01
sudo systemctl status certbot.timer
```

[Add your certificate to AdGuard Home](https://blog.thatopsguy.com/2021/08/lets-encrypt-cert-for-adguard-home/#add-certificate-to-adguard-home)

```bash
# certificate file path
/etc/letsencrypt/live/hole.elbschloss.xyz/fullchain.pem

# private key file
/etc/letsencrypt/live/hole.elbschloss.xyz/privkey.pem
```

## Enable ip-forwarding on Host

```bash
# enable (without rebooting the server)
sysctl -w net.ipv4.ip_forward=1
sysctl -w net.ipv6.conf.all.forwarding=1

# permanently set 
sudo vim /etc/sysctl.conf
```

and ensure `/etc/sysctl.conf` contains

```plain
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 1
```

## Add to tailscale net

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up --advertise-exit-node
```

## Monitoring

### node_exporter

thanks to [Ruan Bekker's Blog](https://blog.ruanbekker.com/blog/2021/10/10/setup-basic-authentication-on-node-exporter-and-prometheus/)

```bash
wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
tar xvfz node_exporter-*.*-amd64.tar.gz
sudo cp node_exporter-*.*-amd64/node_exporter /usr/local/bin/node_exporter
mkdir -p /etc/node-exporter

cat <<EOF > /etc/node-exporter/config.yml
basic_auth_users:
  prometheus: pass
EOF

vim /etc/node-exporter/config.yml

cat <<EOF > /etc/systemd/system/node_exporter.service 
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/node_exporter --web.config=/etc/node-exporter/config.yml

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable node_exporter.service
systemctl start node_exporter.service
systemctl status node_exporter.service
```

### AdGuard Home Exporter

thanks to [ebrianne/adguard-exporter](https://github.com/ebrianne/adguard-exporter)

```bash
wget https://github.com/ebrianne/adguard-exporter/releases/latest/download/adguard_exporter-linux-amd64
chmod +x adguard_exporter-linux-amd64 
sudo cp adguard_exporter-linux-amd64 /usr/local/bin/adguard_exporter

cat <<EOF > /etc/systemd/system/adguard_exporter.service 
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target
Requires=AdGuardHome.service

[Service]
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/adguard_exporter -adguard_protocol https -adguard_hostname hole.elbschloss.xyz -adguard_username admin -adguard_password qwerty -log_limit 10000

[Install]
WantedBy=multi-user.target
EOF

# enter correct username/password
vim /etc/systemd/system/adguard_exporter.service 

systemctl daemon-reload
systemctl enable adguard_exporter.service
systemctl start adguard_exporter.service
systemctl status adguard_exporter.service

```
