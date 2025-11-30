# Setup Guide: Running on Fresh Docker Ubuntu Server

This guide will help you set up and run MySQL, service1, and service2 on a fresh Ubuntu server with Docker.

## Prerequisites

- Ubuntu Server (20.04, 22.04, or 24.04)
- SSH access to the server
- Root or sudo privileges

## Step 1: Install Docker and Docker Compose

### Update system packages
```bash
sudo apt-get update
sudo apt-get upgrade -y
```

### Install Docker
```bash
# Install required packages
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Set up the repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify installation
sudo docker --version
sudo docker compose version
```

### Add your user to docker group (optional, to run without sudo)
```bash
sudo usermod -aG docker $USER
# Log out and log back in for this to take effect
```

## Step 2: Transfer Project Files to Server

### Option A: Using Git (Recommended)
```bash
# On your local machine, ensure code is in a git repository
# Then on the server:
cd ~
git clone <your-repo-url> docker-test
cd docker-test
```

### Option B: Using SCP
```bash
# From your local machine:
scp -r /path/to/docker-test user@server-ip:~/
# Then SSH into server:
ssh user@server-ip
cd ~/docker-test
```

### Option C: Using rsync
```bash
# From your local machine:
rsync -avz /path/to/docker-test user@server-ip:~/
```

## Step 3: Configure Firewall (if enabled)

If you have UFW firewall enabled, open the necessary ports:

```bash
sudo ufw allow 3001/tcp  # service1
sudo ufw allow 3002/tcp  # service2
sudo ufw allow 3306/tcp  # MySQL (optional, only if accessing from outside)
sudo ufw reload
```

**Note:** Only open port 3306 if you need external MySQL access. For security, it's better to keep it closed and access MySQL only from within Docker network.

## Step 4: Verify Files and Build Services

### Navigate to project directory
```bash
cd ~/docker-test  # or wherever you placed the project
```

### Verify all required files are present (optional but recommended)
```bash
# Make verification script executable
chmod +x verify-files.sh
./verify-files.sh
```

Or manually check:
```bash
ls -la service1/Dockerfile service1/package.json service1/index.js
ls -la service2/Dockerfile service2/package.json service2/index.js
ls -la docker-compose.yml
```

### Build and start all services
```bash
sudo docker compose up -d --build
```

This command will:
- Build the Docker images for service1 and service2
- Pull the MySQL 8.4 image
- Create the Docker network
- Start all three services in the background

### Check service status
```bash
sudo docker compose ps
```

You should see all three services (mysql, service1, service2) running.

### View logs
```bash
# View all logs
sudo docker compose logs

# View logs for a specific service
sudo docker compose logs mysql
sudo docker compose logs service1
sudo docker compose logs service2

# Follow logs in real-time
sudo docker compose logs -f
```

## Step 5: Verify Services are Running

### Check service health
```bash
# Check if services are healthy
sudo docker compose ps

# Test service1
curl http://localhost:3001/health
curl http://localhost:3001/

# Test service2
curl http://localhost:3002/
```

### Test from another machine
Replace `your-server-ip` with your actual server IP:
```bash
curl http://your-server-ip:3001/health
curl http://your-server-ip:3001/
curl http://your-server-ip:3002/
```

## Step 6: Common Operations

### Stop all services
```bash
sudo docker compose down
```

### Stop and remove volumes (⚠️ deletes MySQL data)
```bash
sudo docker compose down -v
```

### Restart a specific service
```bash
sudo docker compose restart service1
```

### Rebuild and restart services
```bash
sudo docker compose up -d --build
```

### View resource usage
```bash
sudo docker stats
```

## Step 7: Troubleshooting

### Services won't start
```bash
# Check logs for errors
sudo docker compose logs

# Check if ports are already in use
sudo netstat -tulpn | grep -E '3001|3002|3306'
```

### "Dockerfile: no such file or directory" error
This usually means files weren't transferred correctly. Verify:
```bash
# Check if Dockerfiles exist and are not empty
ls -lh service1/Dockerfile service2/Dockerfile
cat service1/Dockerfile  # Should show content, not be empty

# If files are missing, re-transfer the project
# Make sure to preserve directory structure when transferring
```

### MySQL connection issues
```bash
# Check MySQL logs
sudo docker compose logs mysql

# Test MySQL connection from inside a container
sudo docker compose exec mysql mysql -uappuser -papppass appdb
```

### Service can't connect to MySQL
- Ensure MySQL is healthy: `sudo docker compose ps`
- Check service logs: `sudo docker compose logs service1`
- Verify environment variables are set correctly in docker-compose.yml

### Permission issues with volumes
```bash
# Fix permissions for mysql_data directory
sudo chown -R 999:999 mysql_data
```

### Clean rebuild (removes all containers, images, and volumes)
```bash
sudo docker compose down -v
sudo docker system prune -a
sudo docker compose up -d --build
```

## Service Endpoints

Once running, your services will be available at:

- **Service1 (Wisdom API)**: 
  - Health: `http://your-server-ip:3001/health`
  - Random wisdom: `http://your-server-ip:3001/`
  - All wisdom: `http://your-server-ip:3001/all`
  - Add wisdom: `POST http://your-server-ip:3001/add` (body: `{"text": "your wisdom"}`)
  - Edit: `PUT http://your-server-ip:3001/edit/:id`
  - Delete: `DELETE http://your-server-ip:3001/delete/:id`

- **Service2 (Todo API)**: 
  - Random todo: `http://your-server-ip:3002/`

- **MySQL**: 
  - Host: `your-server-ip` (or `localhost` from server)
  - Port: `3306`
  - User: `appuser`
  - Password: `apppass`
  - Database: `appdb`

## Auto-start on Boot (Optional)

To make services start automatically on server reboot:

```bash
# Create a systemd service
sudo nano /etc/systemd/system/docker-compose-app.service
```

Add the following content:
```ini
[Unit]
Description=Docker Compose Application Service
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/home/your-username/docker-test
ExecStart=/usr/bin/docker compose up -d
ExecStop=/usr/bin/docker compose down
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
```

Replace `/home/your-username/docker-test` with your actual project path.

Then enable and start:
```bash
sudo systemctl daemon-reload
sudo systemctl enable docker-compose-app.service
sudo systemctl start docker-compose-app.service
```

## Security Recommendations

1. **Change default passwords** in `docker-compose.yml`:
   - `MYSQL_ROOT_PASSWORD`
   - `MYSQL_PASSWORD`
   - Update corresponding values in service environment variables

2. **Use environment files** instead of hardcoding passwords:
   ```bash
   # Create .env file
   echo "MYSQL_ROOT_PASSWORD=your-secure-password" > .env
   echo "MYSQL_PASSWORD=your-secure-password" >> .env
   ```
   Then reference in docker-compose.yml: `MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}`

3. **Restrict MySQL port** - Don't expose port 3306 publicly unless necessary

4. **Use reverse proxy** (nginx/traefik) for production with SSL/TLS

5. **Regular updates**: Keep Docker and images updated
   ```bash
   sudo apt-get update && sudo apt-get upgrade -y
   sudo docker compose pull
   sudo docker compose up -d
   ```

## Next Steps

- Set up a reverse proxy (nginx) for production
- Configure SSL certificates (Let's Encrypt)
- Set up monitoring and logging
- Configure automated backups for MySQL data
- Set up CI/CD pipeline for deployments

