FROM alpine 

RUN apk --update add git openssh bash && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/* && \
    mkdir /root/.ssh

VOLUME /git

COPY git.sh /git/git.sh
RUN chmod a+x /git/git.sh
WORKDIR /git

ENTRYPOINT [ "/git/git.sh" ]

CMD []