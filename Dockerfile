FROM alpine

RUN apk --no-cache add git-svn openssh perl-git subversion
ADD data/ /

ENTRYPOINT [ "/init.sh" ]
