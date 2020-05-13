#!/bin/bash

configure_ssmtp() {
    cat > /etc/ssmtp/ssmtp.conf <<EOF
mailhub=${SMTP_HOST}:${SMTP_PORT}

AuthUser=${SMTP_USERNAME}
AuthPass=${SMTP_PASSWORD}
AuthMethod=${SMPT_AUTH_METHOD}

UseTLS=yes
UseSTARTTLS=yes
FromLineOverride=yes
EOF
}

configure_msmtp() {
    cat > /etc/msmtprc <<EOF
host ${SMTP_HOST}
port ${SMTP_PORT}

host mailrelay-exim.services-stage.svc
port 25

tls off
tls_starttls off

add_missing_from_header on

EOF
}

if is_true $ENABLE_SMTP; then
    if [ -x "$(command -v ssmtp)" ]; then
      sectionText "Configure SSMTP"
      configure_ssmtp
    fi
    if [ -x "$(command -v msmtp)" ]; then
      sectionText "Configure MSMTP"
      configure_msmtp
    fi
else
    sectionText "SKIP: SMTP disabled"
fi
