# syntax=docker/dockerfile:1.2

FROM scratch
COPY nix /bin/nix
COPY busybox /bin/busybox
COPY busybox /bin/sh
COPY busybox /usr/bin/env
COPY ca-bundle.crt /etc/ssl/certs/ca-bundle.crt
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt
RUN /bin/busybox ln -sf /bin/busybox /bin/ln
RUN ln -sf /bin/busybox /bin/sh && \
    ln -sf /bin/busybox /bin/sed && \
    ln -sf /bin/busybox /bin/tr && \
    ln -sf /bin/busybox /bin/date && \
    ln -sf /bin/busybox /bin/head && \
    ln -sf /bin/busybox /bin/tar && \
    ln -sf /bin/busybox /bin/hexdump && \
    ln -sf /bin/busybox /bin/mkdir && \
    ln -sf /bin/busybox /bin/rm && \
    ln -sf /bin/busybox /bin/uname && \
    ln -sf /bin/busybox /bin/chmod && \
    ln -sf /bin/busybox /bin/ls && \
    ln -sf /bin/busybox /bin/cat && \
    ln -sf /bin/busybox /bin/xargs && \
    ln -sf /bin/busybox /bin/mkfifo && \
    ln -sf /bin/busybox /bin/echo && \
    ln -sf /bin/busybox /bin/sleep && \
    ln -sf /bin/busybox /bin/seq && \
    ln -sf /bin/busybox /usr/bin/env && \
    ln -sf /bin/busybox /usr/bin/tail

COPY passwd group os-release /etc/
COPY nix.conf /etc/nix/
ENV PATH=/root/.nix-profile/bin:/bin:/usr/bin:/root/.nix-profile/bin
WORKDIR /tmp
WORKDIR /

ENV NIX="exec nix --option use-sqlite-wal false -j auto --substituters https://cache.nixos.org?trusted=1"
RUN $NIX flake show nixpkgs
RUN $NIX shell nixpkgs#coreutils --command echo cached
RUN $NIX shell nixpkgs#bashInteractive --command echo cached
RUN $NIX profile install nixpkgs#s5cmd
RUN $NIX profile install nixpkgs#gitMinimal
RUN $NIX profile install nixpkgs#openssh
RUN $NIX profile install nixpkgs#coreutils.info nixpkgs#coreutils \
nixpkgs#bashInteractive.man nixpkgs#bashInteractive.dev nixpkgs#bashInteractive.info nixpkgs#bashInteractive.doc nixpkgs#bashInteractive \
nixpkgs#gnugrep.info nixpkgs#gnugrep \
nixpkgs#gnutar.info nixpkgs#gnutar \
nixpkgs#gzip.info nixpkgs#gzip.man nixpkgs#gzip
RUN mkdir -p -m 0700 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

#ENTRYPOINT $NIX shell nixpkgs#bashInteractive --command ${CMD-$0 $@}
CMD ["/bin/sh"]
