FROM ubuntu:24.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl ca-certificates build-essential jq unzip \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user matching host UID/GID for seamless bind mounts
# (handles case where 1000 already exists in base image)
ARG USER_ID=1000
ARG GROUP_ID=1000
RUN groupadd -g $GROUP_ID -o devuser 2>/dev/null || true && \
    useradd -m -u $USER_ID -g $GROUP_ID -o -s /bin/bash devuser 2>/dev/null || true

USER devuser
WORKDIR /workspace/odin-doctor
CMD ["bash"]
