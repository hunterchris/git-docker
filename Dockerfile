FROM gradle:4.10-alpine
USER root
WORKDIR /
COPY . /
RUN apk --update  add git openssh bash && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/* && \
    mkdir /root/.ssh && \
    gradle wrapper --gradle-version 2.13

VOLUME /git

COPY git.sh /git/git.sh
RUN chmod a+x /git/git.sh
WORKDIR /git

ENTRYPOINT [ "/git/git.sh" ]

CMD []
