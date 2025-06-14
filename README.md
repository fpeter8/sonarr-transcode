# Sonarr Transcode

[![Build and Publish](https://github.com/fpeter8/sonarr-transcode/actions/workflows/build-publish.yml/badge.svg)](https://github.com/fpeter8/sonarr-transcode/actions/workflows/build-publish.yml)

A Docker image that extends [LinuxServer.io's Sonarr](https://github.com/linuxserver/docker-sonarr) with transcoding capabilities by adding FFmpeg and MKVToolNix.

## Features

- Based on the official LinuxServer.io Sonarr image
- Includes FFmpeg for video/audio transcoding
- Includes MKVToolNix for Matroska file manipulation
- Multi-architecture support (amd64, arm64)
- Automatic base image updates via GitHub Actions
- Published to GitHub Container Registry

## Usage

### Docker Compose

```yaml
version: "3.8"
services:
  sonarr:
    image: ghcr.io/fpeter8/sonarr-transcode:latest
    container_name: sonarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
    volumes:
      - /path/to/config:/config
      - /path/to/tv:/tv
      - /path/to/downloads:/downloads
    ports:
      - 8989:8989
    restart: unless-stopped
```

### Docker Run

```bash
docker run -d \
  --name=sonarr \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -p 8989:8989 \
  -v /path/to/config:/config \
  -v /path/to/tv:/tv \
  -v /path/to/downloads:/downloads \
  --restart unless-stopped \
  ghcr.io/fpeter8/sonarr-transcode:latest
```

## Available Tools

The image includes the following transcoding tools:

### FFmpeg
- `ffmpeg` - Video/audio converter
- `ffprobe` - Multimedia stream analyzer
- `ffplay` - Media player

### MKVToolNix
- `mkvmerge` - Merge multimedia files
- `mkvinfo` - Display information about Matroska files
- `mkvextract` - Extract tracks from Matroska files
- `mkvpropedit` - Modify properties of Matroska files

## Tags

- `latest` - Latest build with the most recent Sonarr version
- `{sonarr_version}-{date}` - Specific Sonarr version built on a specific date (e.g., `4.0.0.748-2024-01-15`)

## Environment Variables

All environment variables from the base LinuxServer.io Sonarr image are supported. See the [LinuxServer.io documentation](https://docs.linuxserver.io/images/docker-sonarr) for details.

## Building Locally

```bash
# Clone the repository
git clone https://github.com/fpeter8/sonarr-transcode.git
cd sonarr-transcode

# Build the image
docker build -t sonarr-transcode .

# Build with specific Sonarr version
docker build --build-arg SONARR_VERSION=4.0.0.748 -t sonarr-transcode:4.0.0.748 .
```

## License

This project is licensed under the MIT License. The base Sonarr image and software have their own licenses.