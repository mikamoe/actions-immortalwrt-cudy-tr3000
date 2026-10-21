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

# Add feed sources
echo "src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki.git;main" >> feeds.conf.default
echo "src-git meowx https://github.com/mmwx-group/meowx-openwrt.git;main" >> feeds.conf.default

# Clone custom packages
git clone https://github.com/eamonxg/luci-theme-aurora.git package/luci-theme-aurora
git clone https://github.com/eamonxg/luci-app-aurora-config.git package/luci-app-aurora-config

# Prepare files directory
mkdir -p files/etc/apk/keys
mkdir -p files/etc/apk/repositories.d

# Download nikki release key
wget -O files/etc/apk/keys/nikki.pem https://nikkinikki.pages.dev/public-key.pem

# Download Aurora release key
wget -O files/etc/apk/keys/eamonxg.pem https://openwrt.eamonxg.fun/eamonxg.pem

# Download MeowX release key
wget -O files/etc/apk/keys/meowx.pem https://dl.miaomiaowux.com/meowx/openwrt/public-key.pem

# Add third-party apk repositories (for updates after flashing)
cat > files/etc/apk/repositories.d/customfeeds.list <<'EOF'
https://nikkinikki.pages.dev/openwrt-25.12/aarch64_cortex-a53/nikki/packages.adb
https://openwrt.eamonxg.fun/snapshots/apk/packages.adb
https://dl.miaomiaowux.com/meowx/openwrt/openwrt-25.12/aarch64_cortex-a53/meowx/packages.adb
EOF
