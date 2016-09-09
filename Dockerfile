FROM alpine

RUN apk --no-cache add git-svn openssh perl-git subversion \
 && mkdir -p /work
ADD data/ /

WORKDIR /work

ENTRYPOINT [ "/init.sh" ]
