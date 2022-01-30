FROM alpine:3.15

ENV TZ=Europe/Madrid
ENV PS1 "\n\n> \W \$ "
ENV TERM=linux

ENV GOTTY_BINARY https://github.com/yudai/gotty/releases/download/v1.0.1/gotty_linux_386.tar.gz

RUN apk add --update \
            --no-cache \
            tini \
            bash  \
            tzdata \
            curl \
            wget \
            git \
            && \
    rm -rf /var/cache/apk && \
    addgroup -g 1000 -S dockerus && \
    adduser -u 1000 -S dockerus -G dockerus -h /home -s bash && \
    mkdir /app && \
    wget $GOTTY_BINARY -O gotty.tar.gz && \
    tar -xzf gotty.tar.gz -C /app/ && \
    rm gotty.tar.gz && \
    chmod +x /app/gotty
COPY ./gotty /home/.gotty
COPY ./start.sh /app/start.sh
RUN chown -R dockerus:dockerus /app /home

USER dockerus
WORKDIR /home

ENTRYPOINT ["tini", "--"]
CMD ["/bin/bash", "/app/start.sh"]

