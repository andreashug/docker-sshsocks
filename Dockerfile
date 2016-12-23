FROM alpine:3.4

RUN apk add --update --no-cache openssh \
    && ssh-keygen -A \
    && mkdir -p /proxy /proxy/.ssh \
    && addgroup -g 1000 -S proxy \
    && adduser -D -G proxy -u 1000 -s /sbin/nologin -h /proxy proxy \
    && sed -i s/proxy:!/proxy:*/ /etc/shadow \
    && touch /proxy/.ssh/authorized_keys \
    && chown -R proxy:proxy /proxy

ADD sshd_config /etc/ssh/sshd_config

EXPOSE 2222

CMD ["/usr/sbin/sshd", "-D", "-e"]
