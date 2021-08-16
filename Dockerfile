FROM debian
MAINTAINER Yuri Vieira
LABEL version="1.0" description="Perforce Server"

RUN apt-get update && apt-get upgrade && apt-get clean -y

COPY p4d /usr/local/bin
RUN chmod +x /usr/local/bin/p4d

# RUN adduser perforce
RUN mkdir /perforce_depot
RUN chown perforce /perforce_depot
RUN mkdir /var/log/perforce
RUN chown perforce /var/log/perforce

RUN export P4JOURNAL=/var/log/perforce/journal
RUN export P4LOG=/var/log/perforce/p4err
RUN export P4ROOT=/perforce_depot
RUN export P4PORT=1666

EXPOSE 1666
WORKDIR /perforce_depot
VOLUME /perforce_depot

ENTRYPOINT ["/usr/local/bin/p4d"]
CMD ["-D", "FOREGROUND"]



