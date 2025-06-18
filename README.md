# Sonarr Transcode

[![Build and Publish](https://github.com/fpeter8/sonarr-transcode/actions/workflows/build-publish.yml/badge.svg)](https://github.com/fpeter8/sonarr-transcode/actions/workflows/build-publish.yml)
[![Check Base Image Updates](https://github.com/fpeter8/sonarr-transcode/actions/workflows/check-base-update.yml/badge.svg)](https://github.com/fpeter8/sonarr-transcode/actions/workflows/check-base-update.yml)

A Docker image that extends [LinuxServer.io's Sonarr](https://github.com/linuxserver/docker-sonarr) with transcoding capabilities by adding FFmpeg and MKVToolNix.

## Features

- Based on the official LinuxServer.io Sonarr image
- Includes FFmpeg for video/audio transcoding
- Includes MKVToolNix for Matroska file manipulation
- Architecture: linux/amd64
- Automated base image updates via GitHub Actions
- Custom script support with automatic copy mechanism
- Version tracking via VERSION file
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
- `{sonarr_version}` - Specific Sonarr version (e.g., `4.0.14.2939-ls284`)
- `{sonarr_version}-{build_number}` - Version with build number (e.g., `4.0.14.2939-ls284-123`)

## Custom Scripts

The image includes an initialization script that copies custom scripts from the config volume to an executable location. This is useful when the config volume is mounted with noexec option.

### How it works:
1. Place your scripts in `/config/scripts/` directory
2. On container start, scripts are automatically copied to `/app/scripts/`
3. Scripts preserve their permissions and are owned by the container user
4. The `/app/scripts/` directory is executable even if `/config` is mounted noexec

### Important Notes for Sonarr Scripts:
- **Single Executable**: Sonarr only accepts a single executable path in its settings. If you need to pass parameters or run multiple commands, create a wrapper shell script.
- **Working Directory**: Scripts executed by Sonarr run from Sonarr's working directory, NOT from `/app/scripts/`. Use absolute paths in your scripts or explicitly change to the required directory.

### Example wrapper script:
```bash
#!/bin/bash
# /config/scripts/transcode-wrapper.sh

# Change to script directory if needed
cd /app/scripts

# Call your actual script with parameters
/app/scripts/transcode.sh --quality high --preset slow "$@"
```

### Docker Compose example:
```yaml
volumes:
  - /path/to/config:/config  # Can be mounted with noexec
  - /path/to/my-scripts:/config/scripts:ro  # Your custom scripts
```

Then in Sonarr, set the custom script path to: `/app/scripts/transcode-wrapper.sh`

## Environment Variables

All environment variables from the base LinuxServer.io Sonarr image are supported. See the [LinuxServer.io documentation](https://docs.linuxserver.io/images/docker-sonarr) for details.

## Version Management

This project uses automated version tracking:

- `VERSION` file contains the current Sonarr version (e.g., `SONARR_VERSION=4.0.14.2939-ls284`)
- Daily automated checks for new LinuxServer.io Sonarr releases
- Automatic PR creation when updates are available
- Version format includes LinuxServer build suffix for exact tracking

## Automated Updates

This image automatically tracks LinuxServer.io's Sonarr releases:

1. Daily checks run at 2 AM UTC via GitHub Actions
2. When a new version is detected, a PR is created with the VERSION file update
3. Merging the PR triggers a new build with the updated version
4. New images are pushed to GitHub Container Registry

To check the current version being tracked, see the [VERSION file](VERSION).

## Building Locally

```bash
# Clone the repository
git clone https://github.com/fpeter8/sonarr-transcode.git
cd sonarr-transcode

# Build the image (version is read from VERSION file)
docker build -t sonarr-transcode .

# The build will use the version specified in the VERSION file
# To override, you can modify the VERSION file before building
```

## License

This project is licensed under the MIT License. The base Sonarr image and software have their own licenses.