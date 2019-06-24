FROM openjdk:11-stretch

MAINTAINER developers@synopsis.cz

RUN apt update && apt -y install make && apt -y install gcc && apt -y remove openssl

RUN apt-get -y install git

RUN cd /usr/src &&
    git clone https://github.com/openssl/openssl.git &&
    cd openssl && git checkout OpenSSL_0_9_8-stable &&
    ./config shared --prefix=/usr/local/openssl/ &&
    make &&
    make install &&
    ln -s /usr/local/openssl/bin/openssl /usr/bin/openssl

CMD tail -f /dev/null