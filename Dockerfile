FROM openjdk:11-stretch

MAINTAINER developers@synopsis.cz

ENV OPENSSL_VERSION="OpenSSL_1_0_1-stable"

#Prerekvizity pre instalaciu
RUN apt update && \
    apt -y install make && \
    apt -y install gcc && \
    apt -y remove openssl

#Git pre clone openssl
RUN apt-get -y install git

#Build a instalacia openssl verzie 1.0.1-stable
RUN cd /usr/src && \
    git clone https://github.com/openssl/openssl.git && \
    cd openssl && git checkout $OPENSSL_VERSION && \
    ./config shared --prefix=/usr/local/openssl/ && \
    make && \
    make install && \
    ln -s /usr/local/openssl/bin/openssl /usr/bin/openssl

#Supervisor ktory nam odpaluje java microservicy
RUN apt-get -y install supervisor && \
    mkdir -p /var/log/supervisor && \
    mkdir -p /etc/supervisor/conf.d

#Tvorba priecinku pre microservicy
RUN mkdir /usr/data /usr/data/tmp
WORKDIR /usr/data

COPY data/TextExtractor.jar /usr/data/TextExtractor.jar
COPY data/PdfPreviewAll.jar /usr/data/PdfPreview.jar
COPY data/supervisord.conf.template /etc/supervisord.conf

CMD ["supervisord", "-c", "/etc/supervisord.conf"]