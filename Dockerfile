FROM openjdk:8-jdk-alpine

ENV SPARK_VERSION=1.5.2
ENV PATH=$PATH:/spark/bin

RUN apk --no-cache add python2 wget bash snappy snappy-dev \
    && wget https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop2.6.tgz \
    && tar -xzf spark-$SPARK_VERSION-bin-hadoop2.6.tgz \
    && mv spark-$SPARK_VERSION-bin-hadoop2.6 /spark \
    && rm spark-$SPARK_VERSION-bin-hadoop2.6.tgz

# Install glibc compatibility for Alpine
RUN apk --no-cache add ca-certificates wget && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.34-r0/glibc-2.34-r0.apk && \
    apk add glibc-2.34-r0.apk

COPY word_count.py /spark/

VOLUME ["/data"]

CMD ["spark-submit", "/spark/word_count.py", "/data/input_file.txt", "/data/output_file.txt"]