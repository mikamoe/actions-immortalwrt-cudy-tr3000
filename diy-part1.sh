#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
# nikki
echo "src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki.git;main" >> feeds.conf.default
mkdir -p files/etc/apk/keys
wget -O files/etc/apk/keys/nikki.pem https://nikkinikki.pages.dev/public-key.pem

# luci-theme-aurora
git clone https://github.com/eamonxg/luci-theme-aurora package/luci-theme-aurora
git clone https://github.com/eamonxg/luci-app-aurora-config package/luci-app-aurora-config

# luci-app-quickfile
git clone https://github.com/sbwml/luci-app-quickfile package/luci-app-quickfile

mkdir -p files/etc/uci-defaults

cat > files/etc/uci-defaults/99-nginx-init <<'EOF'
#!/bin/sh

uci set nginx.global.uci_enable='true'
uci del nginx._lan
uci del nginx._redirect2ssl

uci add nginx server
uci rename nginx.@server[0]='_lan'

uci set nginx._lan.server_name='_lan'
uci add_list nginx._lan.listen='80 default_server'
uci add_list nginx._lan.listen='[::]:80 default_server'
uci add_list nginx._lan.include='conf.d/*.locations'
uci set nginx._lan.access_log='off; # logd openwrt'

uci commit nginx

service nginx restart

exit 0
EOF

chmod +x files/etc/uci-defaults/99-nginx-init
