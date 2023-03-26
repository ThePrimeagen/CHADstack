FROM ubuntu:bionic AS builder
WORKDIR /cow
RUN apt-get update && apt-get install -qy open-cobol
RUN apt-get install -qy apache2 libcob1 build-essential curl libffi-dev libffi6 libgmp-dev libgmp10 libncurses-dev libncurses5 libtinfo5 curl
RUN apt-get install -qy haskell-platform
RUN apt-get install -qy vim
RUN yes | curl --proto '=https' --tlsv1.2 -ksSf https://get-ghcup.haskell.org | sh
COPY CHADstack2.cabal .
COPY app ./app
RUN /root/.ghcup/bin/cabal build

## RUST TIME
# I should really do a multistage build, but then i rememberd i am a true chad
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

RUN /root/.cargo/bin/cargo install cargo-chadr

RUN mkdir /cow/controllers
RUN mkdir /cow/views

COPY pages /cow/pages
COPY run run
COPY downhill.sh downhill.sh
COPY cow.cbl cow.cbl
COPY cowtemplate.cbl cowtemplate.cbl

RUN /root/.cargo/bin/cargo chadr

EXPOSE 80
ENTRYPOINT ["./run"]
CMD [ "bash" ]

# FROM haskell:buster
# RUN apt-get update && apt-get install -qy curl apache2 libcob4 haskell-platform
# COPY --from=builder /cow /cow
# RUN curl -o Cabal.tar.gz https://downloads.haskell.org/~cabal/Cabal-3.8.1.0/Cabal-3.8.1.0.tar.gz
# RUN mkdir /cabal
# WORKDIR /cabal
# RUN tar -xvf ../Cabal.tar.gz
# EXPOSE 80
# CMD [ "-D", "FOREGROUND", "-f", "/cow/apache.conf"]
# ENTRYPOINT [ "/usr/sbin/apachectl" ]

