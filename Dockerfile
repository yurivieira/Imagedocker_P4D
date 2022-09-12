FROM debian
MAINTAINER Yuri Vieira
LABEL version="latest" description="Build Box86 and Perforce Server for RPI4"

RUN apt-get update && apt-get upgrade -y
RUN apt-get install --yes --no-install-recommends git python3 build-essential cmake ca-certificates gcc-arm-linux-gnueabihf
RUN apt-get clean
RUN git clone https://github.com/ptitSeb/box86

RUN mkdir /box86/build
WORKDIR /box86/build
RUN cmake .. -DRPI4=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo
RUN make -j$(nproc)
RUN make install

WORKDIR /
ADD http://ftp.perforce.com/perforce/r22.1/bin.linux26x86/p4d /usr/local/bin/p4d
RUN chmod +x /usr/local/bin/p4d

RUN mkdir /perforce_depot
RUN mkdir /var/log/perforce

RUN export P4JOURNAL=/var/log/perforce/journal
RUN export P4LOG=/var/log/perforce/p4err
RUN export P4ROOT=/perforce_depot
RUN export P4PORT=1666

EXPOSE 1666
WORKDIR /perforce_depot
VOLUME /perforce_depot

#CMD ["/box86/build/box86", "/usr/local/bin/p4d"]

ENTRYPOINT ["/box86/build/box86", "/usr/local/bin/p4d"]
# CMD ["-d"]
ENV P4CLIENT P4CONFIG P4PASSWD P4PORT P4USER

#CMD ["bash"]




