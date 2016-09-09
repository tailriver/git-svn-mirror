FROM alpine

RUN apk --no-cache add git-svn openssh perl-git subversion
ADD data/ /

ENV GIT_SVN_WORKDIR=/work
VOLUME $GIT_SVN_WORKDIR
WORKDIR $GIT_SVN_WORKDIR

ENTRYPOINT [ "/init.sh" ]
