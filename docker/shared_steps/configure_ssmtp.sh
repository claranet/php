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

if is_true $ENABLE_SMTP; then
    sectionText "Configure SSMTP"
    configure_ssmtp
else
    sectionText "SKIP: SMTP disabled"
fi

