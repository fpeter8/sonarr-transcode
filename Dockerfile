ARG SONARR_VERSION=latest
FROM lscr.io/linuxserver/sonarr:${SONARR_VERSION}

# Install ffmpeg and mkvtoolnix
RUN \
    echo "**** install packages ****" && \
    apk add --no-cache \
        ffmpeg \
        mkvtoolnix && \
    echo "**** cleanup ****" && \
    rm -rf \
        /tmp/* \
        /var/cache/apk/*

# Create scripts directory
RUN mkdir -p /app/scripts

# Add custom init script
COPY --chmod=755 custom-cont-init.d /custom-cont-init.d/

# Labels
LABEL maintainer="Peter Farkas <peter@semmiseg.info>"
LABEL org.opencontainers.image.source="https://github.com/fpeter8/sonarr-transcode"
LABEL org.opencontainers.image.description="Sonarr with ffmpeg and mkvtoolnix for transcoding"
LABEL org.opencontainers.image.licenses="MIT"
