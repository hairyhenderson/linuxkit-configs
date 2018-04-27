FROM linuxkit/alpine:f3cd219615428b2bd943411723eb28875275fae7 AS mirror
RUN mkdir -p /out/etc/apk && cp -r /etc/apk/* /out/etc/apk/
RUN mv /out/etc/apk/repositories.upstream /out/etc/apk/repositories
RUN apk add curl
RUN apk add --no-cache --initdb -p /out \
    alpine-baselayout \
    bash \
    busybox \
    iproute2 \
    iptables \
    ebtables \
    ipvsadm \
    bridge-utils \
    musl \
    wireless-tools \
    hostapd

# Remove apk residuals
RUN rm -rf /out/etc/apk /out/lib/apk /out/var/cache

FROM scratch
ENTRYPOINT []
CMD []
WORKDIR /
COPY --from=mirror /out/ /
COPY etc/ /etc/
LABEL org.mobyproject.config='{"capabilities": ["CAP_NET_ADMIN", "CAP_NET_RAW"]}'
