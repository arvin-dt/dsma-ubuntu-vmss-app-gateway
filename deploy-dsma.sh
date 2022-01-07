#!/bin/bash -x

apt-get update

apt-get install -y apt software-properties-common wget
add-apt-repository -y ppa:openjdk-r/ppa && apt-get update
apt-get install -y openjdk-14-jre-headless libssl1.0.0 libssl-dev

PORT=80
if [[ ! -z "$1" ]]; then
  PORT=$1
fi
if [[ -z "$FORTANIX_API_ENDPOINT" ]]; then
  export FORTANIX_API_ENDPOINT="https://smartkey.io"
fi
if [[ ! -z "$2" ]]; then
  export FORTANIX_API_ENDPOINT="$2"
fi

DOWNLOAD_LINK="https://kds.fortanix.net/dsma-010522.tgz"
if [[ ! -z "$3" ]]; then
  DOWNLOAD_LINK=$3
fi

# TBD package structure
mkdir -p /tmp/ftx-dsma/
wget --no-check-certificate $DOWNLOAD_LINK -O /tmp/ftx-dsma/pkg.tgz
cd /tmp/ftx-dsma/
tar xvzf /tmp/ftx-dsma/pkg.tgz
mkdir -p /opt/fortanix/bin
mv src/main/resources/libvalentino.so /opt/fortanix
mv target/demo-0.0.1-SNAPSHOT.jar /opt/fortanix/bin


# env file for the systemd unit
# E2E TLS certs -- TBD
cat <<EOF > /etc/default/ftx-dsma
FORTANIX_API_ENDPOINT=$FORTANIX_API_ENDPOINT
DSMA_PORT=$PORT
EOF

# control file for the systemd unit
# E2E TLS certs -- TBD
cat <<EOF > /etc/systemd/system/ftx-dsma.service
[Unit]
Description=Fortanix DSMA
After=Network.target

[Service]
Type=simple
User=root
Group=root
SyslogIdentifier=ftx-dsma
Restart=on-failure
ExecStart=/usr/bin/java -jar /opt/fortanix/bin/demo-0.0.1-SNAPSHOT.jar --server.port=\${DSMA_PORT}
EnvironmentFile=/etc/default/ftx-dsma
RestartPreventExitStatus=1
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start ftx-dsma.service
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

