# ==============================================================================
# Multi-stage Dockerfile for Retro RTS (C++20 & SDL3)
# ==============================================================================
FROM ubuntu:24.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    ninja-build \
    git \
    ca-certificates \
    libx11-dev \
    libxext-dev \
    libxrandr-dev \
    libxcursor-dev \
    libxi-dev \
    libxss-dev \
    libxfixes-dev \
    libxtst-dev \
    libwayland-dev \
    libxkbcommon-dev \
    wayland-protocols \
    libegl1-mesa-dev \
    libgl1-mesa-dev \
    libdrm-dev \
    libgbm-dev \
    libasound2-dev \
    libpulse-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

# Configure and compile
RUN cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
RUN cmake --build build --parallel

# Run unit tests
RUN ctest --test-dir build --output-on-failure

CMD ["./build/app/openday"]
