#!/bin/bash

set -e

if [ -f /configured ]; then
  exec /usr/bin/supervisord
fi

database_password=$(pwgen -1 -s 12)
echo "DATABASE_PASSWORD: $database_password"
cat >/etc/mysql/init <<EOF
CREATE database limesurvey;
GRANT ALL ON limesurvey.* TO 'limesurvey'@'localhost' IDENTIFIED BY '$database_password';
EOF
password=$(pwgen -1 -s)
echo -e "$password\n$password"|passwd &>/dev/null
echo "PASSWORD: $password"
date > /configured
exec /usr/bin/supervisord
