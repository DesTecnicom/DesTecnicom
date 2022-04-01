#!/bin/bash

apt update && sudo apt upgrade
apt install git python3-pip build-essential wget python3-dev python3-venv python3-wheel libfreetype6-dev libxml2-dev libzip-dev libldap2-dev libsasl2-dev python3-setuptools node-less libjpeg-dev zlib1g-dev libpq-dev libxslt1-dev libldap2-dev libtiff5-dev libjpeg8-dev libopenjp2-7-dev liblcms2-dev libwebp-dev libharfbuzz-dev libfribidi-dev libxcb1-dev xfonts-base xfonts-75dpi libstdc++6 postgresql postgresql-client
useradd -m -d /opt/odoo -U -r -s /bin/bash odoo
echo -e "\e[1;32m@@@@@ DEPENDENCIAS INSTALADAS @@@@@"
echo -e "\e[1;32m@@@@@ SE HA CREADO UN NUEVO USUARIO ODOO, INGRESA UNA CONTRASEÑA @@@@@\e[0m"
passwd odoo
echo -e "odoo ALL=(ALL:ALL) ALL \n" >> /etc/sudoers
su - postgres -c "createuser -s odoo"
mkdir /opt/odoo/odoo-Builds
wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.bionic_amd64.deb -P /opt/odoo/odoo-Builds/
dpkg -i /opt/odoo/odoo-Builds/wkhtmltox_0.12.5-1.bionic_amd64.deb
echo -e "\e[1;32m@@@@@ WKHTMLTOPDF INSTALADO  @@@@@\e[0m"
# su - odoo
git clone https://www.github.com/odoo/odoo --depth 1 --branch 15.0 /opt/odoo/odoo-server
python3 -m venv /opt/odoo/odoo-venv
source /opt/odoo/odoo-venv/bin/activate
pip3 install wheel
pip3 install -r /opt/odoo/odoo-server/requirements.txt
deactivate
mkdir /opt/odoo/odoo-custom-addons
echo -e "[options] \n
; admin_passwd = admin \n
db_host = False \n
db_port = False \n
db_user = odoo  \n
db_passwd = /opt/odoo/odoo-server/addons,/opt/odoo/odoo-custom-addons" > /etc/odoo.conf
echo -e "[Unit] \n
Description=Odoo \n
Requires=postgresql.service \n
After=network.target postgresql.service \n
\n
[Service] \n
Type=simple \n
SyslogIdentifier=odoo15 \n
PermissionsStartOnly=true \n
User=odoo \n
Group=odoo \n
ExecStart=/opt/odoo/odoo-venv/bin/python3 /opt/odoo/odoo-server/odoo-bin -c /etc/odoo.conf \n
StandardOutput=journal+console \n

[Install] \n
WantedBy=multi-user.target" > /etc/systemd/system/odoo.service
echo -e "\e[1;32m@@@@@ FICHEROS DE CONFIGURACIÓN INSTALADOS  @@@@@\e[0m"

systemctl daemon-reload
systemctl start odoo
systemctl enable odoo
echo -e "\e[1;32m@@@@@ ODOO INSTALADO CORRECTAMENTE @@@@@\e[0m"
su - odoo
