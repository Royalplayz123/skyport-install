#!/bin/bash

# ASCII Art
ascii_art="

      _____                   _   _____  _                 
 |  __ \                 | | |  __ \| |                
 | |__) |___  _   _  __ _| | | |__) | | __ _ _   _ ____
 |  _  // _ \| | | |/ _` | | |  ___/| |/ _` | | | |_  /
 | | \ \ (_) | |_| | (_| | | | |    | | (_| | |_| |/ / 
 |_|  \_\___/ \__, |\__,_|_| |_|    |_|\__,_|\__, /___|
               __/ |                          __/ |    
              |___/                          |___/       "

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo_message() {
  echo -e "${CYAN}$1${NC}"
}

# Clear the screen
clear
# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Please run this script as root.${NC}"
  exit 1
fi

echo -e "${CYAN}$ascii_art${NC}"

echo_message "* Installing Dependencies"

# Update package list and install dependencies
sudo apt update
sudo apt install -y curl software-properties-common
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install nodejs -y 
sudo apt install git -y

echo_message "* Installed Dependencies"

echo_message "* Installing Files"

# Create directory, clone repository, and install files
mkdir -p panel5
cd panel5 || { echo_message "Failed to change directory to skyport"; exit 1; }
git clone https://github.com/achul123/panel5.git
cd panel5 || { echo_message "Failed to change directory to panel"; exit 1; }
npm install

echo_message "* Installed Files"

echo_message "* Starting Skyport"

# Run setup scripts
npm run seed
npm run createUser

echo_message "* Starting Skyport With PM2"

# Install panel and start the application
sudo npm install -g pm2
pm2 start index.js

echo_message "* Skyport Installed and Started on Port 3001"

# Clear the screen after finishing
clear
echo "* Made by Royal Playz"
