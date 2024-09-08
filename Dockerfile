# Use the official Python image as a base
FROM python:3.10-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    sudo \
    git \
    curl \
    ssh \
    gnupg \
    software-properties-common \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Add Ansible's official PPA and install Ansible
RUN echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu focal main" | tee /etc/apt/sources.list.d/ansible.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 \
    && apt-get update \
    && apt-get install -y ansible

# Install VS Code Server (for remote development in VS Code)
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Expose the code-server default port
EXPOSE 8080

# Set up a non-root user for security
RUN useradd -ms /bin/bash vscode \
    && echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER vscode
WORKDIR /home/vscode

# Install Python dependencies for Ansible (if needed)
RUN pip install --user ansible-lint

# Command to start VS Code Server
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "none", "--disable-telemetry"]
