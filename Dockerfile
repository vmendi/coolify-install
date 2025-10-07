FROM ubuntu:22.04

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install all prerequisites including those needed by Coolify installer
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    jq \
    openssl \
    ca-certificates \
    sudo \
    openssh-server \
    systemd \
    && rm -rf /var/lib/apt/lists/*

# Configure SSH server
RUN mkdir -p /var/run/sshd && \
    mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# Create a directory for Coolify data
RUN mkdir -p /data/coolify

# Install Docker (required for Coolify)
RUN curl -fsSL https://get.docker.com | sh

# Copy installation script
COPY install-coolify.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/install-coolify.sh

# Expose necessary ports
# 80: HTTP
# 443: HTTPS
# 8000: Coolify API
# 6001: Websockets (Laravel Echo Server)
# 22: SSH for deployments
EXPOSE 80 443 8000 6001 22

CMD ["/usr/local/bin/install-coolify.sh"]

