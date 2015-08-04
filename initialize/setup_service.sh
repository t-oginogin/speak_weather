sudo cp ../config/initd/julius /etc/init.d/
sudo chmod 755 /etc/init.d/julius
sudo cp ../config/initd/speak_weather /etc/init.d/
sudo chmod 755 /etc/init.d/speak_weather
sudo update-rc.d julius defaults
sudo update-rc.d speak_weather defaults

