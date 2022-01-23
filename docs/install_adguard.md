# Installing AdGuard with LetsEncrypt Certificate

## Install AdGuard

```bash
wget https://static.adguard.com/adguardhome/release/AdGuardHome_linux_arm.tar.gz
sudo tar xvf AdGuardHome_linux_arm.tar.gz
cd AdGuardHome
sudo ./AdGuardHome -s install
```

## Issue LE Certificate use dns01 challenge with CloudFlare

special thanks to the amazing tutorial from [that ops guy](https://blog.thatopsguy.com/2021/08/lets-encrypt-cert-for-adguard-home/). Just summarized up for my own purposes:

```bash
apt install certbot python3-certbot-dns-cloudflare
mkdir /root/.secrets/ && touch /root/.secrets/cloudflare.ini
sudo chmod 0700 /root/.secrets/
sudo chmod 0600 /root/.secrets/cloudflare.ini
cat << EOF > /root/.secrets/cloudflare.ini 
dns_cloudflare_email = youremail@example.com
dns_cloudflare_api_key = yourapikey
EOF
vim /root/.secrets/cloudflare.ini
sudo certbot certonly --dns-cloudflare --dns-cloudflare-credentials /root/.secrets/cloudflare.ini -d hole.elbschloss.xyz --preferred-challenges dns-01
sudo systemctl status certbot.timer
```

[Add your certificate to AdGuard Home](https://blog.thatopsguy.com/2021/08/lets-encrypt-cert-for-adguard-home/#add-certificate-to-adguard-home)

## Enable ip-forwarding on Host

```bash
# enable (without rebooting the server)
sysctl -w net.ipv4.ip_forward=1

# permanently set 
sudo vim /etc/sysctl.conf
```

`/etc/sysctl.conf` contains

```plain
net.ipv4.ip_forward = 1
```

## Add to tailscale net

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
```

## Monitoring

### node_exporter

```bash
wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
tar xvfz node_exporter-*.*-amd64.tar.gz
sudo cp node_exporter-*.*-amd64/node_exporter /usr/local/bin/node_exporter

cat <<EOF > /etc/systemd/system/node_exporter.service 
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target
StartLimitIntervalSec=500
StartLimitBurst=5

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
