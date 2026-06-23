# Use Ubuntu 22.04 LTS base image (better support for tools)
FROM ubuntu:latest

# Prevent interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install essential tools
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    gnupg \
    lsb-release \
    ca-certificates \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# ─────────────────────────────────────────────────────────
# Install Python 3
# ─────────────────────────────────────────────────────────
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# ─────────────────────────────────────────────────────────
# Install PowerShell
# ─────────────────────────────────────────────────────────
RUN apt-get update && apt-get install -y \
    gnupg \
    && curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /usr/share/keyrings/microsoft.gpg \
    && echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/ubuntu/22.04/prod jammy main' > /etc/apt/sources.list.d/microsoft-ubuntu-jammy-prod.list \
    && apt-get update \
    && apt-get install -y powershell \
    && rm -rf /var/lib/apt/lists/*

# ─────────────────────────────────────────────────────────
# Install .NET CLI
# ─────────────────────────────────────────────────────────
RUN apt-get update && apt-get install -y \
    wget \
    && wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh \
    && chmod +x dotnet-install.sh \
    && ./dotnet-install.sh --version latest --install-dir /usr/local/dotnet \
    && rm dotnet-install.sh \
    && ln -s /usr/local/dotnet/dotnet /usr/local/bin/dotnet \
    && rm -rf /var/lib/apt/lists/*

# ─────────────────────────────────────────────────────────
# Verify installations
# ─────────────────────────────────────────────────────────
RUN echo "=== Verifying installed tools ===" && \
    python3 --version && \
    pwsh --version && \
    dotnet --version

# Set working directory
WORKDIR /app

# Default command: display versions
CMD ["/bin/bash", "-c", "echo '=== Environment Tools Versions ===' && python3 --version && pwsh --version && dotnet --version"]
