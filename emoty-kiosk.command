#!/bin/bash
 
# This bash script starts a python http server and then launches chrome in kiosk mode
# The http server is killed after chrome is closed
#
# Place the script in the folder where the html files are located
# Add execute permissions to the script with the following command in the terminal:
#
#   chmod +x start.command
# 
# Then double click the script to start the server and launch chrome in kiosk mode
# To stop the server and chrome, close the chrome window
#
# Note: This script is for Mac OS X. It may need to be modified for other operating systems
#
# Note: The script assumes that python3 is installed. If python3 is not installed, 
# it can be installed from https://www.python.org/downloads/
# 
# Note: The script assumes that the python http server is installed. If the python http server
# is not installed, it can be installed with the following command:
# 
#   pip install http.server
# 
# Note: The script assumes that the python http server is run with python3. If python3 is not 
# the default python version, the command may need to be changed to python or python3.7 or similar
#
# Written by Pierre Rossel on 2024-05-15
 
 
# change to the directory where the script is located
cd "$(dirname "$0")"

# Run the WebSocket-Serial-Gateway in the background
echo "Starting WebSocket-Serial-Gateway ..."
python3 ../WebSocket-Serial-Gateway/gateway.py & 
 
# remember the PID of the http server to kill it later
gateway_pid=$!
 
# Run an http server in the background
echo "Starting web server..."
python3 -m http.server 5500 & 
 
# remember the PID of the http server to kill it later
http_server_pid=$!
sleep 1

# Wait for servers to start
echo "Waiting for everything to start..."
sleep 5

# launch chrome in kiosk mode in the foreground
echo "Launching Chrome in kiosk mode..."

/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
--chrome-frame \
--kiosk \
--disable-download-warning \
--autoplay-policy=no-user-gesture-required "http://localhost:5500"
 
# kill the http server after chrome is closed
kill $http_server_pid
 
# kill the gateway after chrome is closed
kill $gateway_pid
 
echo done