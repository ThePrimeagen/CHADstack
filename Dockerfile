FROM ubuntu:focal AS builder
WORKDIR /cow
RUN apt update
RUN apt full-upgrade -qy

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Madrid
RUN apt install -qy tzdata

RUN apt install -qy apt-utils open-cobol apache2 libcob4 build-essential curl libffi-dev libffi7 libgmp-dev libgmp10 libncurses-dev libncurses5 libtinfo5 curl haskell-platform neovim
RUN yes | curl --proto '=https' --tlsv1.2 -ksSf https://get-ghcup.haskell.org | sh
COPY CHADstack2.cabal .
COPY downhill.sh .
COPY app ./app
RUN /root/.ghcup/bin/cabal build

## RUST TIME
# I should really do a multistage build, but then i rememberd i am a true chad
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ARG CACHE_BUST=1
RUN CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse /root/.cargo/bin/cargo install cargo-chadr

COPY pages /cow/pages
COPY run run
COPY downhill.sh downhill.sh

RUN /root/.cargo/bin/cargo chadr -- --version
RUN /root/.cargo/bin/cargo chadr -- chad
RUN cobc -Wall -x -free cow.cbl cowtemplate.cbl `ls -d controllers/*` -o the.cow
RUN /root/.cargo/bin/cargo chadr -- link

EXPOSE 80
ENTRYPOINT ["./run"]
CMD [ "bash" ]

# FROM haskell:buster
# RUN apt update && apt install -qy curl apache2 libcob4 haskell-platform
# COPY --from=builder /cow /cow
# RUN curl -o Cabal.tar.gz https://downloads.haskell.org/~cabal/Cabal-3.8.1.0/Cabal-3.8.1.0.tar.gz
# RUN mkdir /cabal
# WORKDIR /cabal
# RUN tar -xvf ../Cabal.tar.gz
# EXPOSE 80
# CMD [ "-D", "FOREGROUND", "-f", "/cow/apache.conf"]
# ENTRYPOINT [ "/usr/sbin/apachectl" ]

