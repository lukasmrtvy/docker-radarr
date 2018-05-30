FROM alpine:3.7

ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US.UTF-8' \
    TERM='xterm'

ENV RADARR_VERSION='0.2.0.995'

ENV UID 1000
ENV GID 1000
ENV USER htpc
ENV GROUP htpc

ENV XDG_CONFIG_HOME /config/


RUN addgroup -S ${GROUP} -g ${GID} && adduser -D -S -u ${UID} ${USER} ${GROUP}  && \
  echo @testing http://alpine.gliderlabs.com/alpine/edge/testing >> /etc/apk/repositories && \
  apk -U upgrade && \
  apk -U add --no-cache \
    libmediainfo \
    mono@testing \
    curl && \
  mkdir -p /config/ /opt/radarr && curl -sSL https://github.com/Radarr/Radarr/releases/download/v${RADARR_VERSION}/Radarr.develop.${VERSION}.linux.tar.gz | tar xz -C /opt/radarr --strip-components=1 && \
  chown -R ${USER}:${GROUP} /config/ /opt/radarr/ && \
  apk del curl tar

EXPOSE 7878

VOLUME /config/

USER ${USER}

LABEL version=${RADARR_VERSION}
LABEL url=https://github.com/Radarr/Radarr/


ENTRYPOINT ["mono", "/opt/radarr/Radarr.exe", "--no-browser -data=/config"]
