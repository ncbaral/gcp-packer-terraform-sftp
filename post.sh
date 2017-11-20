#!/bin/sh
sudo bash -c "cat >> /etc/ssh/sshd_config" <<EOF
Match User $sftp_user
ForceCommand internal-sftp
PasswordAuthentication yes
ChrootDirectory /var/sftp
PermitTunnel no
AllowAgentForwarding no
AllowTcpForwarding no
X11Forwarding no
EOF

sudo systemctl restart sshd 