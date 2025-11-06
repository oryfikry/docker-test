[SERVER]

[GITHUB]
cd ~/actions-runner  # or wherever your runner is installed
# Install as service (this creates a systemd service)
sudo ./svc.sh install

# Start the service
sudo ./svc.sh start

# Check status
sudo ./svc.sh status

# View logs
sudo ./svc.sh status
# or
journalctl -u actions.runner.* -f

# RESTART / STOP
sudo ./svc.sh stop
sudo ./svc.sh restart

# uninstall services
sudo ./svc.sh uninstall