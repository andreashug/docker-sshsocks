FROM alpine:3.4

MAINTAINER Andreas Hug

RUN apk add --update --no-cache openssh \
    && mkdir -p /proxy \
    && addgroup -g 1000 -S proxy \
    && adduser -D -G proxy -u 1000 -s /sbin/nologin -h /proxy proxy \
    && sed -i s/proxy:!:/proxy:*:/ /etc/shadow \
    && ssh-keygen -A \
    && mv /etc/ssh/ssh_host_*_key /proxy \
    && touch /proxy/sshd.pid \
    && chown -R proxy:proxy /proxy \
    && chmod 0500 /proxy \
    && chmod 0400 /proxy/* \
    && chmod 0600 /proxy/sshd.pid

COPY sshd_config /proxy/sshd_config

EXPOSE 2222
USER proxy

CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/proxy/sshd_config"]
