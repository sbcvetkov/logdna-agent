#!/bin/bash
# Assuming it is running on Debian

# Variables
ARCH=x86
NODE_VERSION=12.13.0
REDHAT=rpm

# Step 1: Install Dependencies
sudo npm cache clean --force
sudo rm -rf ~/.npm/_cacache
sudo npm install -g nexe

# Step 2: Prepare Folders and Files
mkdir -p .build/scripts
cp ./scripts/win32/files/* .build/scripts/

# Step 3: Compile and Build Executable
nexe -i index.js -o .build/logdna-agent.exe -t win32-${ARCH}-${NODE_VERSION}

# Step 4: Debian Packaging
fpm \
	--input-type ${INPUT_TYPE} \
	--output-type ${DEBIAN} \
	--name ${NAME} \
	--version ${VERSION} \
	--license ${LICENSE} \
	--vendor "LogDNA, Inc." \
	--description "LogDNA Agent for Linux" \
	--url "http://logdna.com/" \
	--maintainer "LogDNA, Inc. <support@logdna.com>" \
	--before-remove ./.build/scripts/before-remove \
	--after-upgrade ./.build/scripts/after-upgrade \
	--force --deb-no-default-config-files \
		./.build/logdna-agent=/usr/bin/logdna-agent \
		./.build/scripts/init-script=/etc/init.d/logdna-agent \
		./.build/scripts/logrotate=/etc/logrotate.d/logdna-agent

# Step 5: RedHat Packaging
fpm \
	--input-type ${INPUT_TYPE} \
	--output-type ${REDHAT} \
	--name ${NAME} \
	--version ${VERSION} \
	--license ${LICENSE} \
	--vendor "LogDNA, Inc." \
	--description "LogDNA Agent for Linux" \
	--url "http://logdna.com/" \
	--maintainer "LogDNA, Inc. <support@logdna.com>" \
	--before-remove ./.build/scripts/before-remove \
	--after-upgrade ./.build/scripts/after-upgrade \
	--force \
		./.build/logdna-agent=/usr/bin/logdna-agent \
		./.build/scripts/init-script=/etc/init.d/logdna-agent \
		./.build/scripts/logrotate=/etc/logrotate.d/logdna-agent