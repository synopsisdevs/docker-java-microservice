FROM openjdk:11-stretch

MAINTAINER developers@synopsis.cz

#Prerekvizity pre instalaciu
RUN apt update && \
    apt -y install make && \
    apt -y install gcc && \
    apt -y remove openssl

#Git pre clone openssl
RUN apt-get -y install git

#Build a instalacia openssl verzie 0.9.8-stable
RUN cd /usr/src && \
    git clone https://github.com/openssl/openssl.git && \
    cd openssl && git checkout OpenSSL_0_9_8-stable && \
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