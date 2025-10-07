# Coolify Installation on Flightcontrol

This repository contains configuration to automatically install [Coolify](https://coolify.io/) on Flightcontrol using Nixpacks.

## Configuration Files

- **flightcontrol.json** - Flightcontrol deployment configuration
- **nixpacks.toml** - Nixpacks build configuration
- **install-coolify.sh** - Installation script for Coolify

## How It Works

When deployed to Flightcontrol, the following happens:

1. **Build Phase**: Nixpacks sets up the environment with required packages:
   - curl, wget, ca-certificates
   - openssh-server for SSH access
   - docker.io for running containers

2. **Start Phase**: The `install-coolify.sh` script runs:
   - Starts SSH service
   - Starts Docker daemon
   - Downloads and runs the official Coolify installation script
   - Keeps the container running for access

3. **Access**: Coolify will be accessible on:
   - Port 80 (HTTP)
   - Port 443 (HTTPS)
   - Port 8080 (Health check)

## Deployment

1. Push this repository to GitHub
2. Connect the repository to Flightcontrol
3. Flightcontrol will automatically detect `flightcontrol.json` and deploy

## Important Notes

- This uses an **EC2 instance** (not Fargate) because Coolify requires Docker
- SSH access is enabled for troubleshooting
- The installation may take several minutes to complete
- After deployment, check the logs to ensure Coolify installed successfully

## Post-Installation

After Coolify is installed, you can:
1. Access Coolify at your EC2 instance's public IP on port 80
2. Follow Coolify's setup wizard
3. Use SSH to access the instance if needed for troubleshooting

## Troubleshooting

To check if Coolify is running:
```bash
docker-compose logs -f coolify
```

To restart Coolify:
```bash
docker-compose restart
```
