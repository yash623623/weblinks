#!/usr/bin/env bash
VERSION="$(git rev-parse --short HEAD)"

echo "Started building at $(date) - $(whoami)"

# Update composer
composer self-update

# Install dependencies
composer install --no-interaction --no-progress

google-chrome --version
chmod 755 vendor/joomla-projects/selenium-server-standalone/bin/webdrivers/chrome/linux/chromedriver

cp jorobo.dist.ini jorobo.ini
cp RoboFile.dist.ini RoboFile.ini

# Create the apache root directory then configure the RoboFile to use it for the Joomla Site
mkdir -p /tests/www/tests/joomla
chown -R www-data /tests
sed -i -r 's!^(cmsPath\s*=\s*)(.*)!\1\/tests\/www\/\2!' RoboFile.ini

# Build package
vendor/bin/robo build --dev

# Copy acceptance yml
cp tests/acceptance.suite.dist.yml tests/acceptance.suite.yml
