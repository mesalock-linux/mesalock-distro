FROM scratch
MAINTAINER Mingshen Sun <sunmingshen@baidu.com>

ADD rootfs.tar.xz /

ENV TZ="America/Los_Angeles" RUST_BACKTRACE=1
RUN ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

CMD ["/bin/ion"]
