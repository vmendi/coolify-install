#!/bin/bash

# Don't exit on error - we want to keep the container running
set +e

echo "Starting SSH service..."
service ssh start

echo "Starting Docker service..."
dockerd &
sleep 5

echo "Installing Coolify..."

# Run the Coolify installation script
curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash

if [ $? -eq 0 ]; then
    echo "Coolify installation complete!"
else
    echo "Coolify installation encountered issues, but container will stay running for troubleshooting."
fi

echo "Container is ready. Coolify should be accessible on port 80."
echo "To check logs: docker-compose logs -f coolify"

# Keep container running
tail -f /dev/null

