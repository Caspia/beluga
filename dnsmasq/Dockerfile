FROM alpine:3.8
# note the alpine version above should match whatever alpine is
# used by the node:alpine versions used in other apps to minimize
# image size.

# Adapted from ope-dns of github.com/operepo/ope

RUN apk --no-cache add dnsmasq
EXPOSE 53 53/udp
ENTRYPOINT ["dnsmasq", "-k"]
