# Coolify Docker Setup

This directory contains a Docker setup for running Coolify, a self-hostable deployment platform.

## What's Included

- **Dockerfile**: Based on Ubuntu 22.04 LTS with Coolify installation
- **docker-compose.yml**: Complete orchestration with all necessary ports and volumes
- **install-coolify.sh**: Installation script that runs inside the container

## Ports Exposed

- `80` - HTTP (web UI)
- `443` - HTTPS (web UI)
- `8000` - Coolify API
- `6001` - Websockets for real-time updates
- `2222` - SSH for deployments (mapped from container's port 22)

## Volumes

The following volumes are created to persist data:

- `coolify-data` - Main Coolify data directory (`/data/coolify`)
- `coolify-config` - Coolify configuration files (`/root/.coolify`)
- `coolify-ssl` - SSL certificates (`/etc/letsencrypt`)
- `coolify-db` - PostgreSQL database data (`/var/lib/postgresql`)

Additionally, the Docker socket is mounted to allow Coolify to manage containers.

## Quick Start

1. **Build and start the container:**
   ```bash
   docker-compose up -d --build
   ```
   
   Note: Use `--build` to ensure the latest changes are applied.

2. **View logs to monitor installation:**
   ```bash
   docker-compose logs -f coolify
   ```
   
   The installation may take 5-10 minutes. Watch for "Coolify installation complete!" message.

3. **Access Coolify:**
   - Open your browser and navigate to `http://localhost`
   - The initial setup may take a few minutes

4. **Stop the container:**
   ```bash
   docker-compose down
   ```

5. **Rebuild after changes:**
   ```bash
   docker-compose down
   docker-compose up -d --build
   ```

6. **Stop and remove all data:**
   ```bash
   docker-compose down -v
   ```

## Environment Variables

You can customize the following environment variables in `docker-compose.yml`:

- `COOLIFY_SECRET_KEY` - **Important**: Change this to a random string for security
- `COOLIFY_APP_URL` - The URL where Coolify will be accessible
- `COOLIFY_APP_NAME` - Display name for your Coolify instance

## Accessing Configuration Files

To access the configuration files from your host filesystem:

```bash
# List all volumes
docker volume ls

# Inspect a specific volume to see its location
docker volume inspect coolify_coolify-config

# Access files using docker cp
docker cp coolify:/data/coolify ./local-backup

# Or execute a shell in the container
docker-compose exec coolify bash
```

## Troubleshooting

### Container keeps restarting
If you see the container restarting in a loop:
1. First, stop the container: `docker-compose down`
2. Rebuild with latest changes: `docker-compose up -d --build`
3. Monitor the logs closely: `docker-compose logs -f coolify`

The installation script now pre-installs all required packages and starts services properly before running the Coolify installer.

### Container exits immediately
Check logs: `docker-compose logs coolify`

If you see errors about OpenSSH or missing packages, rebuild the container with `--build` flag.

### Cannot access on port 80
Make sure no other service is using port 80 on your host machine. You can check with:
```bash
lsof -i :80
```

### Permission issues
The container runs in privileged mode to allow proper Docker-in-Docker functionality.

### Installation seems stuck
The Coolify installation can take 5-10 minutes. Be patient and watch the logs. If it takes longer than 15 minutes, there might be an issue.

### Debugging inside the container
To get a shell inside the running container:
```bash
docker-compose exec coolify bash
```

Then you can check service status, logs, etc.

## Security Notes

1. **Change the SECRET_KEY**: Update `COOLIFY_SECRET_KEY` in docker-compose.yml
2. **Use HTTPS**: In production, configure proper SSL certificates
3. **Firewall**: Ensure your firewall only allows necessary ports
4. **Regular updates**: Keep Coolify updated for security patches

## Additional Resources

- [Coolify Documentation](https://coolify.io/docs)
- [Coolify GitHub](https://github.com/coollabsio/coolify)

