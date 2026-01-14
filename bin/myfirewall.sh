#!/bin/sh

# Transmission: port 51413
# SSH: port 22 TCP

# usage: myfirewall.sh -v|-nv

if [ -z "$1" ]; then

    echo "usage: myfirewall.sh -v|-nv"
    echo "    -v: VPN rules"
    echo "    -nv: normal rules"
    exit 1

    else if [ "$1" = "-v" ]; then

        echo "Applying VPN rules..."
        # reset rules
        sudo ufw --force reset >/dev/null
        sudo ufw default deny incoming >/dev/null
        sudo ufw default deny outgoing >/dev/null

        # allow only through VPN tunnel
        sudo ufw allow out on tun0 from any to any >/dev/null

        # allow direct SSH
        sudo ufw allow in on tun0 proto tcp from any to any port 22 >/dev/null

        # allow Transmission
        sudo ufw allow in on tun0 from any to any port 51413 >/dev/null

        # activate firewall
        sudo ufw enable >/dev/null
        echo "Done."

    else

        echo "Applying normal non-VPN rules..."
        # reset rules
        sudo ufw --force reset >/dev/null
        sudo ufw default deny incoming >/dev/null
        sudo ufw default allow outgoing >/dev/null

        # allow direct SSH
        sudo ufw allow 22/tcp >/dev/null

        # allow Transmission
        sudo ufw allow 51413 >/dev/null

        # activate firewall
        sudo ufw enable >/dev/null
        echo "Done."

    fi
fi
